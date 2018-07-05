// ECS629/759 Assignment 2 - ID3 Skeleton Code
// Author: Simon Dixon

import java.io.File;
import java.io.FileReader;
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Scanner;
import java.util.ArrayList;
import java.util.Iterator;

class ID3 {

	/** Each node of the tree contains either the attribute number (for non-leaf
	 *  nodes) or class number (for leaf nodes) in <b>value</b>, and an array of
	 *  tree nodes in <b>children</b> containing each of the children of the
	 *  node (for non-leaf nodes).
	 *  The attribute number corresponds to the column number in the training
	 *  and test files. The children are ordered in the same order as the
	 *  Strings in strings[][]. E.g., if value == 3, then the array of
	 *  children correspond to the branches for attribute 3 (named data[0][3]):
	 *      children[0] is the branch for attribute 3 == strings[3][0]
	 *      children[1] is the branch for attribute 3 == strings[3][1]
	 *      children[2] is the branch for attribute 3 == strings[3][2]
	 *      etc.
	 *  The class number (leaf nodes) also corresponds to the order of classes
	 *  in strings[][]. For example, a leaf with value == 3 corresponds
	 *  to the class label strings[attributes-1][3].
	 **/
	class TreeNode {

		TreeNode[] children;
		int value;

		public TreeNode(TreeNode[] ch, int val) {
			value = val;
			children = ch;
		} // constructor

		public String toString() {
			return toString("");
		} // toString()
		
		String toString(String indent) {
			if (children != null) {
				String s = "";
				for (int i = 0; i < children.length; i++)
					s += indent + data[0][value] + "=" +
							strings[value][i] + "\n" +
							children[i].toString(indent + '\t');
				return s;
			} else
				return indent + "Class: " + strings[attributes-1][value] + "\n";
		} // toString(String)

	} // inner class TreeNode

	private int attributes; 	// Number of attributes (including the class)
	private int examples;		// Number of training examples
	private TreeNode decisionTree;	// Tree learnt in training, used for classifying
	private String[][] data;	// Training data indexed by example, attribute
	private String[][] strings; // Unique strings for each attribute
	private int[] stringCount;  // Number of unique strings for each attribute

	public ID3() {
		attributes = 0;
		examples = 0;
		decisionTree = null;
		data = null;
		strings = null;
		stringCount = null;
	} // constructor

	public void printTree() {
		if (decisionTree == null)
			error("Attempted to print null Tree");
		else
			System.out.println(decisionTree);
	} // printTree()

	/** Print error message and exit. **/
	static void error(String msg) {
		System.err.println("Error: " + msg);
		System.exit(1);
	} // error()

	static final double LOG2 = Math.log(2.0);

  static double xlogx(double x) {
		return x == 0? 0: x * Math.log(x) / LOG2;
	} // xlogx()

	/** Execute the decision tree on the given examples in testData, and print
	 *  the resulting class names, one to a line, for each example in testData.
	 **/
	public void classify(String[][] testData) {
		if (decisionTree == null)
			error("Please run training phase before classification");

    // remove first row
    String [][] dataClean = new String[testData.length-1][testData[0].length];
    for(int j =1 ; j < testData.length ; j++){
        dataClean[j-1] = testData[j];
    }

    for(int i = 0 ; i < dataClean.length ; i++) {
        String obtainedClass = traverseTree(decisionTree, dataClean[i]);
        System.out.println(obtainedClass);
    }
	} // classify()

    private String traverseTree(TreeNode head, String[] example) {
        if(head.children == null) {
            return strings[attributes-1][head.value];
        } else {
            int valIdx = idx(head.value, example[head.value]);
            return traverseTree(head.children[valIdx], example);
        }
    }

	public void train(String[][] trainingData) {
		indexStrings(trainingData);
    ArrayList<Integer> attrskept = new ArrayList<Integer>();
    for(int i = 0 ; i < attributes - 1   ; i++) {
        attrskept.add(Integer.valueOf(i));
    }

    // remove first row (header) as it was interfering with computations
    String [][] dataClean = new String[data.length-1][data[0].length];
    for(int j =1 ; j < data.length ; j++){
        dataClean[j-1] = data[j];
    }

    decisionTree = id3Rec(dataClean, attrskept);
	}

    private int idx(int attribute, String value) {
        // fetch index of value in attribute.
        for(int i = 0 ; i < strings[attribute].length; i++) {
            if(strings[attribute][i].equals(value)) {
                return i;
            }
        }
        throw new RuntimeException("shouldn't happen " + attribute + value + (strings[attribute][0] == value));
    }


    private boolean allSame(String [][] vals) {

        for(int i = 0 ; i < vals.length -1 ; i++) {
            if(!vals[i][attributes-1].equals(vals[i+1][attributes-1])) {
                return false;
            }
        }

        return true;
    }

    private int commonClassIdx(String [][] vals ) {
        int [] freq = new int[strings[attributes-1].length];

        for(int i = 0 ; i < vals.length ; i++) {
            int classIndex = idx(attributes-1, vals[i][attributes-1]);
            freq[classIndex] =  freq[classIndex] + 1;
        }

        int highestFreq = 0;
        for(int j = 0 ; j < freq.length ;j++) {
            if(freq[j] > freq[highestFreq]) {
            highestFreq = j;
            }
        }

    return highestFreq;
    }


    private TreeNode id3Rec(String [][] currExamples, ArrayList<Integer> attrs) {
        if(allSame(currExamples)) {
            return new TreeNode(null , idx(attributes-1,currExamples[0][attributes-1]));
        }

        if(attrs.isEmpty()) {
            return new TreeNode(null,  commonClassIdx(currExamples));
        }

        // for each attr compute information gain relative to examples.. pick most discriminative attr.
        Iterator<Integer> it = attrs.iterator();
        double maxGain = Integer.MIN_VALUE;
        int maxIndex=0;

        while(it.hasNext()) {
            int j= it.next().intValue();
            double currGain = infoGain(currExamples,j);

            if(currGain > maxGain) {
                maxGain = currGain;
                maxIndex = j;
            }
        }

        ArrayList<TreeNode> children = new ArrayList<TreeNode>();
        for(int i = 0 ; i < strings[maxIndex].length ; i++) {
            if(strings[maxIndex][i] == null) {
                continue;
            }
            String attrValue = strings[maxIndex][i];
            String[][] filterExamples = filterValues(currExamples, maxIndex, attrValue );


            if(filterExamples.length == 0) {
                TreeNode leaf = new TreeNode( null , commonClassIdx(filterExamples));
                children.add(leaf);
            } else {
                ArrayList<Integer> copy = (ArrayList<Integer>)attrs.clone();
                copy.remove(Integer.valueOf(maxIndex));
                children.add(id3Rec(filterExamples, copy));
            }
        }
        if(children.size() > 0) {
            return new TreeNode(children.toArray((new TreeNode[children.size()])), maxIndex);
        } else {
            return new TreeNode(null, maxIndex);
        }
    }

    private double entropy(String [][] examples) {
        int numVals =strings[attributes-1].length;
        int realCount=0;
        double entropy = 0;

        for(int i=0; i<  numVals; i++ ) {
            if(strings[attributes-1][i] ==null){
                continue;
            }
            String value = strings[attributes-1][i];
            double proportion = proportion(examples,value);
            entropy = entropy - xlogx(proportion);
        }

        return entropy;
    }

    private double proportion(String[][] examples, String value) {
        int numElements = examples.length;
        int count = 0;

        for(int i=0; i< numElements ; i++) {
            if(examples[i][attributes-1].equals(value)) {
                count++;
            }
        }

        return (numElements == 0)? 0 : ((double)count)/ ((double)numElements);
    }

    private String[] deepCopy(String[] original) {
        int size = original.length;
        String[] copy = new String[size];
        for(int i =0; i < size; i++) {
            copy[i] = new String(original[i]);
        }
        return copy;
    }

    private String[][] filterValues(String[][] examples, int attribute,String value) {
        ArrayList<String[]> filtered = new ArrayList<String[]>();
        for(int i = 0 ; i < examples.length ; i++) {
            if(examples[i][attribute].equals(value)) {
                filtered.add(deepCopy(examples[i]));
            }
        }
        return filtered.toArray(new String[filtered.size()][examples[0].length]);
    }

    private double infoGain(String[][] examples, int attribute) {
        int numVals =strings[attribute].length;
        int realCount = 0;
        double gain = entropy(examples);
        // max val .. because strings can have null indeces

        for(int i=0; i<  numVals; i++ ) {
            if(strings[attribute][i] == null) {
                continue;
            }
            String value = strings[attribute][i];
            double ratio = ((double)filterValues(examples, attribute,value).length) / ((double)examples.length);
            gain = gain - ratio * entropy(filterValues(examples,attribute, value));
        }

        return gain;
    }

	/** Given a 2-dimensional array containing the training data, numbers each
	 *  unique value that each attribute has, and stores these Strings in
	 *  instance variables; for example, for attribute 2, its first value
	 *  would be stored in strings[2][0], its second value in strings[2][1],
	 *  and so on; and the number of different values in stringCount[2].
	 **/
	void indexStrings(String[][] inputData) {
		data = inputData;
		examples = data.length;
		attributes = data[0].length;
		stringCount = new int[attributes];
		strings = new String[attributes][examples];// might not need all columns
		int index = 0;
		for (int attr = 0; attr < attributes; attr++) {
			stringCount[attr] = 0;
			for (int ex = 1; ex < examples; ex++) {
				for (index = 0; index < stringCount[attr]; index++)
					if (data[ex][attr].equals(strings[attr][index]))
						break;	// we've seen this String before
				if (index == stringCount[attr])		// if new String found
					strings[attr][stringCount[attr]++] = data[ex][attr];
			} // for each example
		} // for each attribute
	} // indexStrings()

	/** For debugging: prints the list of attribute values for each attribute
	 *  and their index values.
	 **/
	void printStrings() {
		for (int attr = 0; attr < attributes; attr++)
			for (int index = 0; index < stringCount[attr]; index++)
				System.out.println(data[0][attr] + " value " + index +
									" = " + strings[attr][index]);
	} // printStrings()
		
	/** Reads a text file containing a fixed number of comma-separated values
	 *  on each line, and returns a two dimensional array of these values,
	 *  indexed by line number and position in line.
	 **/
	static String[][] parseCSV(String fileName)
								throws FileNotFoundException, IOException {
		BufferedReader br = new BufferedReader(new FileReader(fileName));
		String s = br.readLine();
		int fields = 1;
		int index = 0;
		while ((index = s.indexOf(',', index) + 1) > 0)
			fields++;
		int lines = 1;
		while (br.readLine() != null)
			lines++;
		br.close();
		String[][] data = new String[lines][fields];
		Scanner sc = new Scanner(new File(fileName));
		sc.useDelimiter("[,\n]");
		for (int l = 0; l < lines; l++)
			for (int f = 0; f < fields; f++)
				if (sc.hasNext())
					data[l][f] = sc.next();
				else
					error("Scan error in " + fileName + " at " + l + ":" + f);
		sc.close();
		return data;
	} // parseCSV()

	public static void main(String[] args) throws FileNotFoundException,
												  IOException {
		if (args.length != 2)
			error("Expected 2 arguments: file names of training and test data");
		String[][] trainingData = parseCSV(args[0]);
		String[][] testData = parseCSV(args[1]);
		ID3 classifier = new ID3();
		classifier.train(trainingData);
		classifier.printTree();
		classifier.classify(testData);
	} // main()

} // class ID3
