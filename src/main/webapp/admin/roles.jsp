<%@page language = "java" %>
<%@page import = "org.jahia.bin.*" %>
<%@page import = "java.util.*" %>
<% List aclNameList = (List) request.getAttribute("aclNameList");
final Integer userNameWidth = new Integer(15);
request.getSession().setAttribute("userNameWidth", userNameWidth);
final String selectUsrGrp = (String) request.getAttribute("selectUsrGrp"); %>
<%@include file="/admin/include/header.inc" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%
stretcherToOpen   = 0; %>
<internal:gwtGenerateDictionary/>
<internal:gwtImport module="org.jahia.ajax.gwt.module.contentmanager.ContentManager" />
<div id="topTitle">
  <h1>Jahia</h1>
  <h2 class="edit"><fmt:message key="label.serverroles"/></h2>
</div>
<div id="main">
  <table style="width: 100%;" class="dex-TabPanel" cellpadding="0" cellspacing="0">
    <tbody>
      <tr>
        <td style="vertical-align: top;" align="left">
          <%@include file="/admin/include/tab_menu.inc" %>
        </td>
      </tr>
      <tr>
        <td style="vertical-align: top;" align="left" height="100%">
          <div class="dex-TabPanelBottom">
            <div class="tabContent">
                <jsp:include page="/admin/include/left_menu.jsp">
                    <jsp:param name="mode" value="server"/>
                </jsp:include>
              <div id="content" class="fit">
                  <div class="head headtop">
                      <div class="object-title">
                          <fmt:message key="label.serverroles"/>
                      </div>
                  </div>
                  <div class="content-item-noborder">
                      <internal:contentManager embedded="true" conf="rolesmanager"/>
                  </div>
              </div>
            </div>
            </div>
            </td>
          </tr>
          </tbody>
        </table>
        </div>
        <div id="actionBar">
          <span class="dex-PushButton">
            <span class="first-child">
              <a  class="ico-back" href='<%=JahiaAdministration.composeActionURL(request,response,"displaymenu","")%>'><fmt:message key="label.backToMenu"/></a>
            </span>
          </span>
          <%--
          <span class="dex-PushButton">
            <span class="first-child">
              <a class="ico-ok" href="#ok" onclick="document.jahiaAdmin.submit(); return false;"><fmt:message key="org.jahia.admin.saveChanges.label"/></a>
            </span>
          </span>
          --%>
        </div>
      </div><%@include file="/admin/include/footer.inc" %>
