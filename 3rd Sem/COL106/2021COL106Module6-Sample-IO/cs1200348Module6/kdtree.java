import java.io.*;
import java.util.ArrayList;
import java.util.Scanner;

public class kdtree {

    private static TreeNode rootnode;
    public static int numCoordinates;
    public static int iterator=0;

    public static class Pair<A, B>{
        public A First;
        public B Second;
        public Pair(){

        }
        public Pair(A _first, B _second) {
            this.First = _first;
            this.Second = _second;
        }
        public A get_first() {
            return First;
        }
        public B get_second() {
            return Second;
        }
    }

    public static class TreeNode{
        public TreeNode parent;
        public TreeNode left;
        public TreeNode right;
        public int x;
        public int y;
        public int x1 ,x2,y1,y2;
        public int numberLeaves;
        public boolean isLeaf;
        public int level;
    }

    public static TreeNode build( ArrayList<Pair<Integer,Integer>> input,int level,int x1,int x2,int y1,int y2,TreeNode parent){
        ArrayList<Pair<Integer,Integer>> restaurants;
        iterator++;
        if(level%2==0){
            restaurants = new MergeSortX(input).sortX();
            int median = (restaurants.size()-1)/2;
            TreeNode node = new TreeNode();
            node.x=restaurants.get(median).First;
            node.y=restaurants.get(median).Second;
            node.parent=parent;
            node.x1 =x1;
            node.x2=x2;
            node.y1=y1;
            node.y2=y2;
            node.level=level;
            if(restaurants.size()>1){
                node.isLeaf=false;
                node.left = build(new ArrayList<>(restaurants.subList(0, median + 1)),level+1,x1,node.x,y1,y2,node);
                node.right = build(new ArrayList<>(restaurants.subList(median + 1, restaurants.size())),level+1,node.x,x2,y1,y2,node);
                node.numberLeaves=node.left.numberLeaves+node.right.numberLeaves;
            }else {
                node.isLeaf=true;
                node.numberLeaves=1;
            }
            return node;
        }else{
            restaurants = new MergeSortY(input).sortY();
            int median = (restaurants.size()-1)/2;
            TreeNode node = new TreeNode();
            node.x=restaurants.get(median).First;
            node.y=restaurants.get(median).Second;
            node.parent=parent;
            node.x1 =x1;
            node.x2=x2;
            node.y1=y1;
            node.y2=y2;
            if(restaurants.size()>1){
                node.isLeaf=false;
                node.left = build(new ArrayList<>(restaurants.subList(0, median + 1)),level+1,x1,x2,y1,node.y,node);
                node.right = build(new ArrayList<>(restaurants.subList(median + 1, restaurants.size())),level+1,x1,x2,node.y,y2,node);
                node.numberLeaves=node.left.numberLeaves + node.right.numberLeaves;
            }else {
                node.isLeaf=true;
                node.numberLeaves=1;
            }
            return node;
        }

    }

    public static int query(Pair<Integer,Integer> pair,int level, TreeNode node){
        int x = pair.First;
        int y = pair.Second;
//        System.out.println(node.x1+" "+node.x2+" "+node.y1+" "+node.y2+" "+x+" "+y+" ");
        if(node.x1 > x-100 && node.x2<= x+100 && node.y1>y-100 && node.y2 <=y+100){
            return node.numberLeaves;
        }else{
            if(node.x1 >= x+100 || node.x2 < x-100 || node.y1 >= y+100 || node.y2 < y-100){
                return 0;
            } else{
                int a=0,b=0;
                if(node.left!=null && !node.isLeaf){
                    a=query(pair,level+1,node.left);
                }
                if(node.right!=null && !node.isLeaf){
                    b=query(pair,level+1,node.right);
                }
                if(node.isLeaf){
                    if(node.x >= x-100 && node.x<= x+100 && node.y>=y-100 && node.y <=y+100){
                        return 1;
                    }
                }
                return a+b;
            }
        }
    }

    public static void main(String[] args) {
        ArrayList<Pair<Integer,Integer>> restaurants = new ArrayList<>();
        ArrayList<Pair<Integer,Integer>> queries = new ArrayList<>();
        try{
            FileInputStream restaurantsStream = new FileInputStream("restaurants.txt");
            FileInputStream queriesStream = new FileInputStream("queries.txt");
            Scanner s = new Scanner(restaurantsStream);

            s.nextLine();
            while (s.hasNextLine()){
                String line = s.nextLine();
                String[] strings = line.split(",");
                int a = Integer.parseInt(strings[0]);
                int b = Integer.parseInt(strings[1]);
                Pair<Integer,Integer> pair = new Pair<>(a,b);
                restaurants.add(pair);
            }

            s = new Scanner(queriesStream);

            s.nextLine();
            while (s.hasNextLine()){
                String line = s.nextLine();
                String[] strings = line.split(",");
                int a = Integer.parseInt(strings[0]);
                int b = Integer.parseInt(strings[1]);
                Pair<Integer,Integer> pair = new Pair<>(a,b);
                queries.add(pair);
            }



        }catch (Exception e){
            System.out.println(e);
        }
        rootnode = build(restaurants,0,Integer.MIN_VALUE,Integer.MAX_VALUE,Integer.MIN_VALUE,Integer.MAX_VALUE,null);
        numCoordinates=rootnode.numberLeaves;

        try {
            FileOutputStream fs = new FileOutputStream ("output.txt",false );
            PrintStream p = new PrintStream (fs );
            for (Pair<Integer,Integer> i : queries){
                p.println(query(i, 0, rootnode));
            }
        }catch (Exception e){
            System.out.println(e.getMessage());
        }

    }

    public static class MergeSortX {
        private ArrayList<Pair<Integer,Integer>> inputArray;

        public ArrayList<Pair<Integer,Integer>> sortX() {
            divide(0, this.inputArray.size()-1);
            return inputArray;
        }

        public MergeSortX(ArrayList<Pair<Integer,Integer>> inputArray){
            this.inputArray = (ArrayList<Pair<Integer, Integer>>) inputArray.clone();
        }


        public void divide(int startIndex,int endIndex){

            if(startIndex<endIndex && (endIndex-startIndex)>=1){
                int mid = (endIndex + startIndex)/2;
                divide(startIndex, mid);
                divide(mid+1, endIndex);

                merger(startIndex,mid,endIndex);
            }
        }

        public void merger(int startIndex,int midIndex,int endIndex){

            ArrayList<Pair<Integer,Integer>> mergedSortedArray = new ArrayList<Pair<Integer,Integer>>();

            int leftIndex = startIndex;
            int rightIndex = midIndex+1;

            while(leftIndex<=midIndex && rightIndex<=endIndex){
                if(inputArray.get(leftIndex).First<=inputArray.get(rightIndex).First){
                    mergedSortedArray.add(inputArray.get(leftIndex));
                    leftIndex++;
                }else{
                    mergedSortedArray.add(inputArray.get(rightIndex));
                    rightIndex++;
                }
            }

            while(leftIndex<=midIndex){
                mergedSortedArray.add(inputArray.get(leftIndex));
                leftIndex++;
            }

            while(rightIndex<=endIndex){
                mergedSortedArray.add(inputArray.get(rightIndex));
                rightIndex++;
            }

            int i = 0;
            int j = startIndex;
            while(i<mergedSortedArray.size()){
                inputArray.set(j, mergedSortedArray.get(i++));
                j++;
            }
        }
    }

    public static class MergeSortY {
        private ArrayList<Pair<Integer,Integer>> inputArray;

        public ArrayList<Pair<Integer,Integer>> sortY() {
            divide(0, this.inputArray.size()-1);
            return inputArray;
        }

        public MergeSortY(ArrayList<Pair<Integer,Integer>> inputArray){
            this.inputArray = (ArrayList<Pair<Integer, Integer>>) inputArray.clone();
        }


        public void divide(int startIndex,int endIndex){

            //Divide till you breakdown your list to single element
            if(startIndex<endIndex && (endIndex-startIndex)>=1){
                int mid = (endIndex + startIndex)/2;
                divide(startIndex, mid);
                divide(mid+1, endIndex);

                //merging Sorted array produce above into one sorted array
                merger(startIndex,mid,endIndex);
            }
        }

        public void merger(int startIndex,int midIndex,int endIndex){

            //Below is the mergedarray that will be sorted array Array[i-midIndex] , Array[(midIndex+1)-endIndex]
            ArrayList<Pair<Integer,Integer>> mergedSortedArray = new ArrayList<Pair<Integer,Integer>>();

            int leftIndex = startIndex;
            int rightIndex = midIndex+1;

            while(leftIndex<=midIndex && rightIndex<=endIndex){
                if(inputArray.get(leftIndex).Second<=inputArray.get(rightIndex).Second){
                    mergedSortedArray.add(inputArray.get(leftIndex));
                    leftIndex++;
                }else{
                    mergedSortedArray.add(inputArray.get(rightIndex));
                    rightIndex++;
                }
            }

            //Either of below while loop will execute
            while(leftIndex<=midIndex){
                mergedSortedArray.add(inputArray.get(leftIndex));
                leftIndex++;
            }

            while(rightIndex<=endIndex){
                mergedSortedArray.add(inputArray.get(rightIndex));
                rightIndex++;
            }

            int i = 0;
            int j = startIndex;
            //Setting sorted array to original one
            while(i<mergedSortedArray.size()){
                inputArray.set(j, mergedSortedArray.get(i++));
                j++;
            }
        }
    }
}
