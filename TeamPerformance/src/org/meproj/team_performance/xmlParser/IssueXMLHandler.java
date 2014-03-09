package org.meproj.team_performance.xmlParser;

import java.io.FileWriter;
import java.io.IOException;
import java.util.List;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

public class IssueXMLHandler extends DefaultHandler{

	private List<String> columns;
	private String rowEndElement;
	private StringBuilder row;
	private FileWriter fileWriter;
	private boolean appendColumn = false;
	private String projectName;
	
	public IssueXMLHandler(List<String> columns, String rowEndElement, String writeLocation, String projectName) throws IOException {
		
		this.columns = columns;
		this.rowEndElement = rowEndElement;
		fileWriter = new FileWriter(writeLocation);
		row = new StringBuilder();
		this.projectName = projectName;
	}

	@Override
	public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
		super.startElement(uri, localName, qName, attributes);
		
		if(columns.contains(qName)) {
			appendColumn = true;
		}
	}
	
	@Override
	public void endElement(String uri, String localName, String qName) throws SAXException {
		super.endElement(uri, localName, qName);
		
		if(qName.equals(rowEndElement)) {
			
			row.append(projectName).append(System.lineSeparator());
			
			try {
				System.out.println("IssueXMLHandler.endElement() row " + row.toString() );
				fileWriter.write(row.toString());
				row = new StringBuilder();
			} catch (IOException e) {
				throw new SAXException(e);
			}
		}
	}
	
	@Override
	public void characters(char[] ch, int start, int length) throws SAXException {
		super.characters(ch, start, length);
		 
		if(appendColumn) {
			row.append(ch, start, length).append(";");
			appendColumn = false;
		}
	}
	@Override
	public void endDocument() throws SAXException {
		// TODO Auto-generated method stub
		super.endDocument();
		try {
			fileWriter.close();
		} catch (IOException e) {}
	}
	
}