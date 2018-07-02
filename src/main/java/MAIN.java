
/**
 * Copyright (C) 2016, GIAYBAC
 * 
* Released under the MIT license
 */
//package com.example;

import com.example.PDFTableExtractor;
import com.example.Table;
import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Map;
import javax.sql.DataSource;
import org.apache.log4j.PropertyConfigurator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.SpringApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import com.google.common.collect.LinkedListMultimap;
import com.google.common.collect.Multimap;
import com.google.common.primitives.Ints;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import org.apache.log4j.xml.DOMConfigurator;

/**
 *
 * @author thoqbk
 */
@Controller
@SpringBootApplication

public class MAIN {

    @Value("${spring.datasource.url}")
    private String dbUrl;

    @Autowired
    private DataSource dataSource;
    public static String carptausuario = "_Docs";
    public static String carptausuarioExtract = "result";
    public static File Fresult;

  //  private static final Logger logger = LoggerFactory.getLogger(MAIN.class);
    /**
     * -in: source <br/>
     * -out: target  <br/>
     * -el: except lines. Ex: 1,2,3-1,6@8 #line 6 in page 8  <br/>
     * -p: page  <br/>
     * -ep: except page <br/>
     * -h: help
     *
     *
     */
    public static void main(String[] args) throws Exception {

//        SpringApplication.run(MAIN.class, args);
      //  DOMConfigurator.configure("log4j.xml");
       // String[] args1 ={"dssd","dsdfs"};
        //String[] args1={"-in","idx.pdf","-out","idx.html","-el","0,1,-1"};
        //Log4jInitListener
        //by logging.config="file:/data/log/report-log4j.properties";
        //PropertyConfigurator.configure(MAIN.class.getResource("/com/giaybac/traprange/log4j.properties"));
        //createTempFile("_Docs", "");
        // File  path = new File (System.getProperty("user.dir")+carptausuario);
        File validator = new File(System.getProperty("user.dir") + "\\target\\" + carptausuario);
        Fresult = new File(System.getProperty("user.dir") + "\\target\\" + carptausuario + "\\" + carptausuarioExtract);

        if (args.length == 1 && "-h".equals(args[0])) {
            // SpringApplication.run(MAIN.class, args);
            System.out.println("printHelp");
            printHelp();
        } else {
            //SpringApplication.run(MAIN.class, args);
            for (int i = 0; i < 5; i++) {
                
            
            String[] args1 = {"-in",carptausuario+"/sample-"+i+".pdf", "-out",carptausuario+"/"+carptausuarioExtract+"/idx"+i+".html", "-el", "0,1,-1"};
            extractTables(args1);


        
        
    }
    }
}


/* @RequestMapping("/")
 String index() {
 return "index";
 }*/
public static boolean directori(File  directorio){

        boolean si;
        if(directorio.isDirectory()){
            System.out.println("El directorio existe " + directorio.getAbsolutePath());
            Fresult.mkdir();
            si=true;
            
        }else{
            directorio.mkdir();
            Fresult.mkdir();
            
               }
        System.out.println(directorio.getAbsolutePath());
        System.out.println(Fresult.getAbsolutePath());
        
        return true;
    }
  

//String filePath = Paths.get(homeDirectory, "_Docs", "sample-1.pdf").toString();
            
        /*    File file = new File(homeDirectory + "\\" + nombre);
//--
            //Path toCreatePath = Paths.get(file.toURI());
            String filePath = Paths.get(homeDirectory, "_Docs", "sample-1.pdf").toString();
            
            if (!d.exists(filePath)) {
                Files.createDirectories(filePath);
            }*/
  
     

    
    
    
    private static void extractTables(String[] args) {
        try {
            List<Integer> pages = getPages(args);
            List<Integer> exceptPages = getExceptPages(args);
            List<Integer[]> exceptLines = getExceptLines(args);
            String in = getIn(args);
            String out = getOut(args);

            PDFTableExtractor extractor = (new PDFTableExtractor())
                    .setSource(in);
            //page
            for (Integer page : pages) {
                extractor.addPage(page);
            }
            //except page
            for (Integer exceptPage : exceptPages) {
                extractor.exceptPage(exceptPage);
            }
            //except lines
            List<Integer> exceptLineIdxs = new ArrayList();
            
            Multimap<Integer, Integer> exceptLineInPages = LinkedListMultimap.create();
            for (Integer[] exceptLine : exceptLines) {
                if (exceptLine.length == 1) {
                    exceptLineIdxs.add(exceptLine[0]);
                } else if (exceptLine.length == 2) {
                    int lineIdx = exceptLine[0];
                    int pageIdx = exceptLine[1];
                    exceptLineInPages.put(pageIdx, lineIdx);
                }
            }
            if (!exceptLineIdxs.isEmpty()) {
                extractor.exceptLine(Ints.toArray(exceptLineIdxs));
            }
            if (!exceptLineInPages.isEmpty()) {
                for (int pageIdx : exceptLineInPages.keySet()) {
                    extractor.exceptLine(pageIdx, Ints.toArray(exceptLineInPages.get(pageIdx)));
                }
            }
            //begin parsing pdf file
            List<Table> tables = extractor.extract();

            Writer writer = new OutputStreamWriter(new FileOutputStream(out), "UTF-8");
            try {
                for (Table table : tables) {
                    writer.write("Page: " + (table.getPageIdx() + 1) + "\n");
                    writer.write(table.toHtml());
                }
            } finally {
                try {
                    writer.close();
                } catch (Exception e) {
                }
            }
        } catch (Exception e) {
           // logger.error(null, e);
            System.err.println("NULL" + e);
        }
    }

    private static void printHelp() {
        StringBuilder help = new StringBuilder();
        help.append("Argument list: \n")
                .append("\t-in: (required) absolute pdf location path. Ex: \"/Users/thoqbk/table.pdf\"\n")
                .append("\t-out: (required) absolute output file. Ex: \"/Users/thoqbk/table.html\"\n")
                .append("\t-el: except lines. For example, to exept lines 1,2,3 and -1 (last line) in all pages and line 4 in page 8, the value shoud be: \"1,2,3,-1,4@8\"\n")
                .append("\t-p: only parse these pages. Ex: 1,2,3\n")
                .append("\t-ep: all pages except these pages. Ex: 1,2\n")
                .append("\t-h: help\n")
                .append("---");
       // logger.info(help.toString());
        System.out.println(help.toString());
    }

    private static List<Integer> getPages(String[] args) {
        return getInts(args, "p");
    }

    private static List<Integer> getExceptPages(String[] args) {
        return getInts(args, "ep");
    }

    private static List<Integer> getInts(String[] args, String name) {
        List<Integer> retVal = new ArrayList();
        String intsInString = getArg(args, name);
        if (intsInString != null) {
            String[] intInStrings = intsInString.split(",");
            for (String intInString : intInStrings) {
                try {
                    retVal.add(Integer.parseInt(intInString.trim()));
                } catch (Exception e) {
                    throw new RuntimeException("Invalid argument (-" + name + "): " + intsInString, e);
                }
            }
        }
        return retVal;
    }

    private static List<Integer[]> getExceptLines(String[] args) {
        List<Integer[]> retVal = new ArrayList();
        String exceptLinesInString = getArg(args, "el");
        if (exceptLinesInString == null) {
            return retVal;
        }
        //ELSE:
        String[] exceptLineStrings = exceptLinesInString.split(",");
        for (String exceptLineString : exceptLineStrings) {
            if (exceptLineString.contains("@")) {
                String[] exceptLineItems = exceptLineString.split("@");
                if (exceptLineItems.length != 2) {
                    throw new RuntimeException("Invalid except lines argument (-el): " + exceptLinesInString);
                } else {
                    try {
                        int lineIdx = Integer.parseInt(exceptLineItems[0].trim());
                        int pageIdx = Integer.parseInt(exceptLineItems[1].trim());
                        retVal.add(new Integer[]{lineIdx, pageIdx});
                    } catch (Exception e) {
                        throw new RuntimeException("Invalid except lines argument (-el): " + exceptLinesInString, e);
                    }
                }
            } else {
                try {
                    int lineIdx = Integer.parseInt(exceptLineString.trim());
                    retVal.add(new Integer[]{lineIdx});
                } catch (Exception e) {
                    throw new RuntimeException("Invalid except lines argument (-el): " + exceptLinesInString, e);
                }
            }
        }
        return retVal;
    }

    private static String getOut(String[] args) {
        String retVal = getArg(args, "out", null);
        if (retVal == null) {
            throw new RuntimeException("Missing output location");
        }
        return retVal;
    }

    private static String getIn(String[] args) {
        String retVal = getArg(args, "in", null);
        if (retVal == null) {
            throw new RuntimeException("Missing input file");
        }
        return retVal;
    }

    private static String getArg(String[] args, String name, String defaultValue) {
        int argIdx = -1;
        for (int idx = 0; idx < args.length; idx++) {
            if (("-" + name).equals(args[idx])) {
                argIdx = idx;
                break;
            }
        }
        if (argIdx == -1) {
            return defaultValue;
        } else if (argIdx < args.length - 1) {
            return args[argIdx + 1].trim();
        } else {
            throw new RuntimeException("Missing argument value. Argument name: " + name);
        }
    }

    private static String getArg(String[] args, String name) {
        return getArg(args, name, null);
    }
}
