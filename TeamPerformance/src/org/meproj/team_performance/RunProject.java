package org.meproj.team_performance;

import java.io.IOException;

import org.hadoop.mr.MRConfig;
import org.hadoop.utils.format.FormatHandler.Formats;

public class RunProject {

	public static void main(String[] args) {
		
		MRConfig config = new MRConfig();
		try {
			config.startMR("svn_jan2014", "svn_jan2014_mr", Formats.SVN_LOG);
		} catch (ClassNotFoundException | IOException | InterruptedException e) {
			
			e.printStackTrace();
		}
	}
}
