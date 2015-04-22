package za.co.olamide.ussd;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.Serializable;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class USSDEngine implements Serializable
	{
	static private final long serialVersionUID = 1L;
	static private Log logger = LogFactory.getLog(USSDEngine.class);
	
	public static final String SessionKey = "USSD-ENGINE-KEY";
	
	private String menuUUID;
	private String workspaceUUID;
	private String selectedIndex;
	private String selectedText;
	private String baseURL;
	private USSDMenu currentMenu;
	
	public USSDEngine(String name,String aURL)
		{
		USSDWorkspace workspace;
		
		workspace = USSDWorkspace.workspaceForName(name);
		workspaceUUID = workspace.uuid;
		menuUUID = "";
		baseURL = aURL;
		currentMenu = workspace.startMenu();
		}
	
	public String selectMenuItem(HttpServletRequest request)
		{
		USSDMenuItem menuItem;
		int menuIndex = 0;
		String command;
		
		command = request.getParameter("menuItemIndex");
		try
			{
			try
				{
				menuIndex = Integer.parseInt(command);
				}
			catch(Exception exxception)
				{
				transitionToInvalidSelectionMenu();
				}
			menuItem = currentMenu.itemAtIndex(menuIndex);
			if (menuItem == null)
				{
				transitionToInvalidSelectionMenu();
				}
			else
				{
				menuItem.executeInContext(this,request);
				}
			}
		catch(Exception exception)
			{
			logger.error(exception);
			exception.printStackTrace();
			}
		return(renderedContent(request.getSession()));
		}
	
	public String renderedContent(HttpSession session)
		{
		return(currentMenu.asXMLForSession(session,baseURL));
		}
	
	public void transitionToInvalidSelectionMenu()
		{
		}
	}
