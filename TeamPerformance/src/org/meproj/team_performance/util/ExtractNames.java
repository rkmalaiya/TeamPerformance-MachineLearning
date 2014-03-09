package org.meproj.team_performance.util;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class ExtractNames {

	private String[] fileNames;
	private BufferedWriter writer; 
	
	public ExtractNames(String projectName, String... fileNames) throws IOException {
		this.fileNames = fileNames;
		writer = new BufferedWriter(new FileWriter(projectName + ".csv"));
	}
	
	public void writeNamesInCSV() throws IOException {
		
		String row = "svn;email;issues" + System.lineSeparator();
		writer.write(row);
		
		BufferedReader svnReader = new BufferedReader(new FileReader(fileNames[0]));
		BufferedReader emailReader = new BufferedReader(new FileReader(fileNames[1]));
		BufferedReader issuesReader = new BufferedReader(new FileReader(fileNames[2]));
		
		String svnLine = "";
		String emailLine = "";
		String issuesLine = "";
		
		while (svnLine != null || (emailLine != null) || (issuesLine != null)) {
			try {
				svnLine = svnReader.readLine();
				emailLine = emailReader.readLine();
				issuesLine = issuesReader.readLine();
				
				if(svnLine == null) {svnLine = "	";}
				if(emailLine == null) {emailLine = "	";}
				if(issuesLine == null) {issuesLine = ";";}
				
				String svnName = svnLine.split("	")[0];
				String emailName = emailLine.split("	")[0];
				String issuesName = issuesLine.split(";")[0];
				
				row = svnName + ";" + emailName + ";" + issuesName + System.lineSeparator();
				System.out.println("ExtractNames.writeNamesInCSV() row " + row);
				writer.write(row);
			} catch (Exception e) {}
		}
	}
	
	public static void main(String[] args) throws IOException {
		new ExtractNames("AllNames", "svn_jan2014_mr_output/part-r-00000", "email_jan2014_mr_output/part-r-00000", "email_jan2014_mr_output/part-r-00000").writeNamesInCSV();
	}
	
}
