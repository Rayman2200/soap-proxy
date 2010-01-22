package com.ecs.soap.proxy.util;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringWriter;

import javax.xml.XMLConstants;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.validation.SchemaFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import com.ecs.soap.proxy.config.Configuration;


public class Utils {

	public static final SchemaFactory schemaFactory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);

	public static Element parseXMLRootElement(String s) throws ParserConfigurationException, SAXException, IOException {
		return parseXMLRootElement(s.getBytes());
	}

	public static Element parseXMLRootElement(byte[] byteArray) throws ParserConfigurationException, SAXException, IOException {
		return parseXMLRootElement(new ByteArrayInputStream(byteArray));
	}

	public static Element parseXMLRootElement(File file) throws ParserConfigurationException, SAXException, IOException {
		return parseXMLRootElement(new FileInputStream(file));
	}

	public static Node parseXMLSchemaNode(File file) throws ParserConfigurationException, SAXException, IOException {
		return parseXMLSchemaNode(new FileInputStream(file));
	}

	public static Node parseXMLSchemaNode(byte[] byteArray) throws ParserConfigurationException, SAXException, IOException {
		return parseXMLSchemaNode(new ByteArrayInputStream(byteArray));
	}

	public static Node parseXMLSchemaNode(InputStream is) throws ParserConfigurationException, SAXException, IOException {
		Document document = Configuration.getInstance().getDocumentBuilder().parse(is);
		String xsdNamespaceURI = XMLConstants.W3C_XML_SCHEMA_NS_URI;
		NodeList schemaNodes = document.getElementsByTagNameNS(xsdNamespaceURI, "schema");
		Node schemaNode = schemaNodes.item(0);
		return schemaNode;
	}

	public static Element parseXMLRootElement(InputStream is) throws ParserConfigurationException, SAXException, IOException {
		Document document = Configuration.getInstance().getDocumentBuilder().parse(is);
		Element root = document.getDocumentElement();
		return root;
	}

	public static String nodeToString(Node node) throws TransformerException {
		TransformerFactory transfac = TransformerFactory.newInstance();
		Transformer trans = transfac.newTransformer();
		trans.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
		trans.setOutputProperty(OutputKeys.INDENT, "yes");
		StringWriter sw = new StringWriter();
		StreamResult result = new StreamResult(sw);
		DOMSource source = new DOMSource(node);
		trans.transform(source, result);
		String content = sw.toString();
		return content;
	}

}
