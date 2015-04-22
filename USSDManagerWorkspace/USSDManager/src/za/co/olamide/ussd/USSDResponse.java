package za.co.olamide.ussd;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement()
public class USSDResponse 
	{
	@XmlElement()
	public boolean successful;
	@XmlElement()
	public int errorCode;
	@XmlElement()
	public Object result;
	
	public USSDResponse()
		{
		successful = true;
		errorCode = 0;
		}
	
	public USSDResponse(Object anObject)
		{
		this();
		result = anObject;
		}
	}
