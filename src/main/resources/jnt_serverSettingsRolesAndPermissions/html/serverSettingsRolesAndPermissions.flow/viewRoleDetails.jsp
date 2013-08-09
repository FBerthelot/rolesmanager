<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<jcr:node var="sites" path="/sites"/>
<jcr:nodeProperty name="j:defaultSite" node="${sites}" var="defaultSite"/>
<c:set var="defaultPrepackagedSite" value="acmespace.zip"/>
<template:addResources type="javascript"
                       resources="jquery.min.js,jquery-ui.min.js,admin-bootstrap.js,bootstrap-filestyle.min.js,jquery.tristate.js"/>

<template:addResources type="css" resources="jquery-ui.smoothness.css,jquery-ui.smoothness-jahia.css,tristate.css"/>

<jsp:useBean id="nowDate" class="java.util.Date"/>
<fmt:formatDate value="${nowDate}" pattern="yyyy-MM-dd-HH-mm" var="now"/>

<div class="clearfix">
    <h2>
        <form class="pull-left" action="${flowExecutionUrl}" method="POST">
            <button class="btn" name="_eventId_rolesList"><i class=" icon-chevron-left"></i>&nbsp;Back</button>
        </form>
        &nbsp;Roles and permissions : ${handler.roleBean.name}
    </h2>
</div>
<c:forEach var="msg" items="${flowRequestContext.messageContext.allMessages}">
    <div class="alert ${msg.severity == 'ERROR' ? 'validationError' : ''} ${msg.severity == 'ERROR' ? 'alert-error' : 'alert-success'}">
        <button type="button" class="close" data-dismiss="alert">&times;</button>
            ${fn:escapeXml(msg.text)}
    </div>
</c:forEach>


<form id="form" action="${flowExecutionUrl}" method="post">
    <%@include file="viewRoleHeader.jspf"%>

    <p>
    </p>


    <fieldset>
        <div>
            <label for="title"><fmt:message key="label.title"/></label>
            <input type="text" name="title" id="title" value="${handler.roleBean.title}"/>
        </div>
        <div>
            <label for="description"><fmt:message key="label.description"/></label>
                <textarea id="description" name="description">${handler.roleBean.description}</textarea>
        </div>
        <div>
            <label for="hidden"><fmt:message key="rolesmanager.rolesAndPermissions.hidden"/></label>
                <input name="hidden" id="hidden" type="checkbox" ${handler.roleBean.hidden?'checked="true"':''} />
        </div>

    </fieldset>

</form>