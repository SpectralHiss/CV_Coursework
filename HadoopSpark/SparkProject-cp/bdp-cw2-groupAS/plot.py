import pandas
import matplotlib.pyplot as plt
from pandas.plotting import parallel_coordinates
from ast import literal_eval as make_tuple


data = pandas.read_table("final_data.txt")

list = []
for c in data.columns:
    datatup = make_tuple(c)
    list.append([datatup[0]]+ datatup[1])


parallel_coordinates(data, "Avg. ups ppost","rep.","total fav. count", "avg. fav. ppost", "Cluster" )
