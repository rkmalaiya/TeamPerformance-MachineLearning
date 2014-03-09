package org.meproj.team_performance.xmlParser;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.xml.sax.SAXException;

public class XmlParser {

	private String readfileName;
	private IssueXMLHandler handler;
	private String rowEndElement;
	private String projectName;
	
	public XmlParser(String readfileName, String rowEndElement, String projectName) {
		super();
		this.readfileName = readfileName;
		this.rowEndElement = rowEndElement;
		this.projectName = projectName;
	}
	
	public void createCSVFile(List<String> columns, String writeLocation) throws SAXException, IOException, ParserConfigurationException {
		
		handler = new IssueXMLHandler(columns, rowEndElement, writeLocation, projectName);
		
		SAXParserFactory factory = SAXParserFactory.newInstance();
		SAXParser saxParser = factory.newSAXParser();
		
		saxParser.parse(readfileName, handler);
	}
	
	public static void main(String[] args) throws SAXException, IOException, ParserConfigurationException {
		
		List<String> columns = new ArrayList<>();
		columns.add("type");
		columns.add("priority");
		columns.add("created");
		columns.add("updated");
		columns.add("votes");
		columns.add("watches");
		columns.add("assignee");
		
		new XmlParser("issues_jan2014/issues-hadoop-common.xml", "item","hadoop-common-project").createCSVFile(columns, "issues_jan2014_csv/issues-hadoop-common.csv");
		new XmlParser("issues_jan2014/issues-hadoop-hbase.xml", "item","hbase").createCSVFile(columns, "issues_jan2014_csv/issues-hadoop-hbase.csv");
		new XmlParser("issues_jan2014/issues-hadoop-hdfs.xml", "item","hadoop-hdfs-project").createCSVFile(columns, "issues_jan2014_csv/issues-hadoop-hdfs.csv");
		new XmlParser("issues_jan2014/issues-hadoop-hive.xml", "item","hive").createCSVFile(columns, "issues_jan2014_csv/issues-hadoop-hive.csv");
		new XmlParser("issues_jan2014/issues-hadoop-MR.xml", "item","hadoop-mapreduce-project").createCSVFile(columns, "issues_jan2014_csv/issues-hadoop-MR.csv");
		new XmlParser("issues_jan2014/issues-hadoop-pig.xml", "item","pig").createCSVFile(columns, "issues_jan2014_csv/issues-hadoop-pig.csv");
		new XmlParser("issues_jan2014/issues-hadoop-yarn.xml", "item","hadoop-yarn-project").createCSVFile(columns, "issues_jan2014_csv/issues-hadoop-yarn.csv");
	}
}