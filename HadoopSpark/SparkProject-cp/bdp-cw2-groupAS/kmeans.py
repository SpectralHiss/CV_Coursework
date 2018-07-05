from pyspark import SparkConf, SparkContext
import testpoints
import itertools
import xml.etree.ElementTree as ET
import operator


conf = (SparkConf()
         .setAppName("KMEAN"))
sc = SparkContext(conf = conf)

sc.setCheckpointDir("out/stackoverflowcheckpoints/")

Logger= sc._jvm.org.apache.log4j.Logger
logger = Logger.getLogger(__name__)

def converPostToPair(post):
    tuple = ET.fromstring(post)
    key = tuple.get('OwnerUserId')
    favoriteCount = float(tuple.get('FavoriteCount', '0'))
    value = (float(1), favoriteCount)
    return (key, value)

def createUserPair(user):
    tuple = ET.fromstring(user)
    key = tuple.get('Id')
    upvotes = float(tuple.get('UpVotes'))
    reputation = float(tuple.get('Reputation'))
    value = (upvotes, reputation)
    return (key, value)


K = 7
MAX_ITERATIONS=15
THRESHOLD=0.1

# HELPERS
def distance_metric(x1,x2):
    # manhattan, dim unknown
    dim_pairs = zip(x1,x2)
    sum = 0
    for (dx1,dx2) in dim_pairs:
        sum += abs(dx1 - dx2)
    return sum;

def min_center(p, curr_centroids):

    min_dist= float("inf")
    min_index = -1
    for i,c in enumerate(curr_centroids):
        temp_dist = distance_metric(p,c)
        if temp_dist< min_dist:
            min_index = i
            min_dist = temp_dist
    return min_index

def sum_points(a,b):
    return [a + b for  (a,b) in zip(a,b)]

def div_vector(count_sum_centroids):
    # caution this is a python map..
    return map(lambda centroid_val: float(centroid_val)/ float(count_sum_centroids[0]),count_sum_centroids[1])

def extract_centers(centers):
    centroid_arr = [None]*K
    for elem in centers:
        centroid_arr[elem[0]] = elem[1]
    return centroid_arr

def below_threshold(c1s,c2s):
    return all([ distance_metric(c1,c2) < THRESHOLD for c1,c2 in zip(c1s,c2s)])




#Get the user data
user = sc.textFile('/data/stackoverflow/Users').filter(lambda x : 'Id' in x);
userPair = user.filter(lambda x : all(ord(c) < 128 for c in x)).map(createUserPair)

#Get the post data
posts = sc.textFile('/data/stackoverflow/Posts').filter(lambda x : 'Id' in x)
postPair = posts.filter(lambda x : all(ord(c) < 128 for c in x)).map(converPostToPair).reduceByKey(lambda x,y : tuple(map(operator.add, x, y)))

joinedData = userPair.join(postPair)

# Gives out : (userid, total upvotes of user / total post of user, reputation, total favoriteCount, total fav. count / total posts)
finalData = joinedData.map(lambda x : (x[0], x[1][0][0] / x[1][1][0], x[1][0][1], x[1][1][1], x[1][1][1] / x[1][1][0]))

# MAIN CODE:

curr_centroids = map(lambda center: center[1:], finalData.takeSample(False,K))

# all points are assigned to index 0 center intially
curr_points_assignment = finalData.map(lambda datapoint_w_id: (0,datapoint_w_id))

# for debug/illustration purposes we store the history of centroids

all_centroids = []

for i in range (1,MAX_ITERATIONS):
    #E step
    # please note that we need to slice the datapoint to skip userid
    Estep = curr_points_assignment.map(lambda a : (min_center(a[1][1:],curr_centroids), a[1][1:]))
    #M step
    #   mean is not associative, hence we need to run the counts seperately and the sum
    # for each cluster using the aggregatebyK functionality of spark
    init_accum = (0,[0,0,0,0])

    # first lambda is inter-parition func, partial sums and counts
    # second lambda merge partial sums and counts.

    sum_counts_centroids = Estep.aggregateByKey(init_accum, \
        lambda accum, new_elem: (accum[0]+1, sum_points(accum[1],new_elem)), \
        lambda accum1,accum2: (accum1[0]+accum2[0], sum_points(accum1[1],accum2[1])))

    curr_centroids = extract_centers(sum_counts_centroids.map(lambda count_sum_centroids : \
                                                              (count_sum_centroids[0] , \
                                                div_vector(count_sum_centroids[1]))).collect())


    if(len(all_centroids) > 1 and below_threshold(curr_centroids,all_centroids[-1])):
        logger.info("bailing early due to close center {0}".format(curr_centroids))
        break
    all_centroids.append(curr_centroids)

logger.info("\n\n!!!!!\n {0} \n!!!!!!!!\n".format(all_centroids))
# we have our final centroids let's save the final point assignment in HDFS for further analysis
last_centroids = all_centroids[-1]
logger.info("\n\n!!!!!\n Last centroids (indexes are important) {0} \n!!!!!!!!\n".format(last_centroids))

final_clustering = curr_points_assignment.map(lambda a : [a[1][1:]] + [min_center(a[1][1:],last_centroids)])


final_clustering.saveAsTextFile("out/final_data_stackoverflow")



