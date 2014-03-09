package org.meproj.team_performance;

import java.io.IOException;
import java.text.ParseException;

import org.hadoop.mr.MRConfig;
import org.hadoop.mr.WordCount;
import org.hadoop.mr.clustering.KMeansCluster;
import org.hadoop.utils.format.FormatHandler.Formats;
import org.hadoop.vector.Vector;
import org.meproj.team_performance.xmlParser.XmlParser;

public class RunProject {

	public static void main(String[] args) {
		
		MRConfig config = new MRConfig();
		
		Vector vector = new Vector();
		
//		try {
//			//config.startMR("svn_jan2014", "svn_jan2014_mr_output", Formats.SVN_LOG);
//			config.startMR("email_jan2014", "email_jan2014_mr_output", Formats.MAIL_CSV);
//			
//			
//		} catch (ClassNotFoundException | IOException | InterruptedException e) {
//			
//			e.printStackTrace();
//		}
//		
		try {
			//vector.createAndWrite("svn_jan2014_mr_output/part-r-00000", "hadoop-mapreduce-project", "svn_jan2014_vector/svn_jan2014_vector_file.txt");
			vector.createAndWrite("email_jan2014_mr_output/part-r-00000", "hadoop-mapreduce-project", "email_jan2014_vector/email_jan2014_vector_file.txt");
		} catch (IOException | ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
//		
		try {
			KMeansCluster cluster = new KMeansCluster();
			//cluster.startClustering("svn_jan2014_vector", "svn_jan2014_canopy", "svn_jan2014_kmeansCluster");
			cluster.startClustering("email_jan2014_vector", "email_jan2014_canopy", "email_jan2014_kmeansCluster");
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
				
//		WordCount count = new WordCount();
//		try {
//			count.main1(new String[]{"svn_jan2014_mr_output", "svn_jan2014_mr_output_count"});
//		} catch (Exception e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
	}
}
