// $License: NOLICENSE
//--------------------------------------------------------------------------------
/**
  @file $relPath
  @copyright $copyright
  @author hflasch
*/

#uses "CtrlPv2Admin"
#uses "pmon"
#uses "CtrlHTTP"

//--------------------------------------------------------------------------------
/*!
 * @brief Handler for Log Viewer endpoints.
 */
class LogViewerHttpEndpoints
{
  static const string URL_BASE = "/logs";

//@public members
  /**
    @brief Connects HTTP endpoints needed for log viewer. To be called from
           `webclient_http.ctl`.
    @param httpsPort HTTPS port used by the server.
  */
  public static void connectEndpoints(int httpsPort)
  {
    if (!isEnabled())
    {
      httpConnect(httpNotFound, URL_BASE + "*", "text/html"); // "custom 404"

      throwError(makeError("", PRIO_INFO, ERR_PARAM, 0, "LogViewer interface is disabled by config, see section [logViewer]"));
      return;
    }
    DebugTN("httpConnect", URL_BASE);

  	httpConnect(logs, URL_BASE);
  	httpConnect(logfile, URL_BASE + "/read");
  	httpConnect(logPage, URL_BASE + "/logViewer.html");
  }

  static string logs()
  {
	dyn_string files = getFileNames(LOG_REL_PATH, "*");
	string formDoc = "<html><head><title>Logs</title>"
				 "<body><h1>Logs</h1>";

  	formDoc +=	"<table>"
				"<tr><th>File</th><th></th><th>Filesize (Kb)</th></tr>";
  	for(int i = 1; i <= dynlen(files); i++)
  	{
		string filePath = LOG_REL_PATH + files[i];
		long fileSize = getFileSize(filePath) / 1024;
  		formDoc +=	"<tr><td><a href=\"" + URL_BASE + "/logViewer.html?file=" + files[i] + "\">" + files[i] + "</a></td><td><a href=\"" + URL_BASE + "/logs/read?raw&file=" + files[i] + "\">(raw)</a></td><td>" + fileSize + "</td></tr>";
  	}
  	formDoc +=	"</table>";
  	formDoc +=	 "</body></html>";
    return formDoc;
  }

  static string logPage(dyn_string names, dyn_string values, string user, string ip, dyn_string headerNames, dyn_string headerValues, int idx)
  {
    string res;
    fileToString(PROJ_PATH + "/data/html/logViewer.html", res);
    mapping query = httpGetQuery(idx);
    res.replace("***FILE***",  query["file"]);
    return res;

  }

  static blob logfile(dyn_string names, dyn_string values, string user, string ip, dyn_string headerNames, dyn_string headerValues, int idx)
  {
    mapping query = httpGetQuery(idx);
  	string filePath = LOG_REL_PATH + query["file"];
    int since = mappingHasKey(query, "since") ? query["since"] : 1;
	int limit = mappingHasKey(query, "limit") ? query["limit"] : 0;

    if (mappingHasKey(query, "raw"))
    {
      file f = fopen(filePath, "rb");
      blob data;
      fread(f, data);
      fclose(f);
      return data;
    }

    long fileSize = getFileSize(filePath);
    dyn_string lines;
    if (fileSize > 0)
    {
      file f = fopen(filePath, "rb");

      int k = 1;
      while (!feof(f))
      {
        string res;
        int rc = fgets(res, fileSize, f);
        if (rc > 0)
        {
          if (k > since)
          {
            dynAppend(lines, res);
			if (limit > 0 && dynlen(lines) > limit)
			{
				dynRemove(lines, 1);
			}
          }
          k++;
        }
      }
      fclose(f);
    }
    mapping obj = makeMapping("lines", lines, "lastId", since + dynlen(lines));
    return jsonEncode(obj);
  }


//@private members
  /** Returns custom 404 error:
    @return { "errorText" : "logviewer interface is disabled by config" }
  */
  private static string httpNotFound()
  {
    return jsonEncode(makeMapping("errorText", "Log viewer interface is disabled by config"));
  }

  /** Determines if logviewer interface is enabled or not. Interface is disabled by default.
    Section: httpLogViewer
    Key: enabled
    @return true, if enabled, otherwise false.
  */
  private static bool isEnabled()
  {
    bool isDflt;
    bool enabled =paCfgReadValue(CFG_PATH, "httpLogViewer", "enabled", true, isDflt);
    return enabled;
  }
};
