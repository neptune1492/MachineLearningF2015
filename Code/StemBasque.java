import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringReader;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.TokenStream;
import org.apache.lucene.analysis.Tokenizer;
import org.apache.lucene.analysis.core.LowerCaseFilter;
import org.apache.lucene.analysis.core.StopFilter;
import org.apache.lucene.analysis.eu.BasqueAnalyzer;
import org.apache.lucene.analysis.miscellaneous.KeywordMarkerFilter;
import org.apache.lucene.analysis.snowball.SnowballFilter;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.analysis.standard.StandardFilter;
import org.apache.lucene.analysis.standard.StandardTokenizer;
import org.apache.lucene.analysis.tokenattributes.CharTermAttribute;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.document.StringField;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.index.IndexWriterConfig;
import org.apache.lucene.index.IndexWriterConfig.OpenMode;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.FSDirectory;
import org.tartarus.snowball.SnowballProgram;
import org.tartarus.snowball.ext.BasqueStemmer;


public class StemBasque {

	public static void main(String[] args) throws IOException {
		int count = 1;
		String section;
		String SavePath = "D:\\Kaggle\\stemFiles\\testTweets\\";
		PrintWriter writer;
		String f;
		File dir = new File("D:\\Kaggle\\MachineLearningF2015-master\\MachineLearningF2015-master\\combined");
		
		  File[] directoryListing = dir.listFiles();
		  if (directoryListing != null) {
		    for (File child : directoryListing) {
		
		writer = new PrintWriter(SavePath + child.toPath().getName(child.toPath().getNameCount() - 1), "UTF-8" );
				
				
			
		List<String> a = parseKeywords(new BasqueAnalyzer(), "field", readFile(child.toPath().toString(), StandardCharsets.UTF_8));
		for (int i = 0; i<a.size(); i++){
		
			writer.print(a.get(i) + " ");
			}
		writer.close();
		count = count +1;
		    }//end loop of children
		  }//end if dir is null
	}
    public static List<String> parseKeywords(Analyzer analyzer, String field, String keywords) throws IOException {

        List<String> result = new ArrayList<String>();
        TokenStream stream  = analyzer.tokenStream(field, new StringReader(keywords));
        stream.reset();
        try {
            while(stream.incrementToken()) {
                result.add(stream.getAttribute(CharTermAttribute.class).toString());
            }
        }
        catch(IOException e) {
            // not thrown b/c we're using a string reader...
        }

        return result;
    }  

		
		
	
	static String readFile(String path, Charset encoding) 
			  throws IOException 
			{
			  byte[] encoded = Files.readAllBytes(Paths.get(path));
			  return new String(encoded, encoding);
			}

}
