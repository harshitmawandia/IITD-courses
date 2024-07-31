package com.company;

import java.io.*;
import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Main {

    public static void main(String[] args) throws IOException {
        File file = new File("D:\\IITD\\3rd Sem\\SearchString\\src\\com\\company\\website.txt");
        BufferedReader br
                = new BufferedReader(new FileReader(file));
        StringBuilder result = new StringBuilder();
        String st;
        // Consition holds true till
        // there is character in a string
        while ((st = br.readLine()) != null) {
            result.append(st).append("\n");
        }
        Pattern pattern =Pattern.compile("<p class=\"name\">(.*?)</p>");
        Matcher matcher = pattern.matcher(result);

        ArrayList<String> names = new ArrayList<>();
        ArrayList<String> emails = new ArrayList<>();
//        System.out.println(result);
        while(matcher.find()){
            String name = matcher.group(1);
//            name = name.split(">")[1];
//            String[] namess =  name.split(",");
//            name = namess[1]+" "+namess[0];
            names.add(name);
        }
        System.out.println(names);

        Pattern pattern1 = Pattern.compile("<script>emailWrite\\(\\'(.*?)\\'\\)");
        Matcher matcher1 = pattern1.matcher(result);
        while ( matcher1.find()){
            String email = matcher1.group(1);
//            email+="@cs.princeton.edu";
            email = email.replace("^*","@");
//            email= email.substring(2,email.length()-2);
//            System.out.println(email);

            emails.add(email);
        }
//        System.out.println(emails);

        BufferedWriter writer = new BufferedWriter(new FileWriter("names.txt",false ));
        BufferedWriter writer1 = new BufferedWriter(new FileWriter("emails.txt", false));

        StringBuilder name = new StringBuilder();
        StringBuilder email = new StringBuilder();
        System.out.println(names.size()+" "+ emails.size());
//        names.remove(0);
        try {
            for (int i = 0; i < emails.size(); i++) {
                name.append(names.get(i)).append("\n");
                email.append(emails.get(i)).append("\n");
            }
        }catch (Exception e){

        }
        writer.append(name);
        writer.close();
        writer1.append(email);
        writer1.close();
    }
}
