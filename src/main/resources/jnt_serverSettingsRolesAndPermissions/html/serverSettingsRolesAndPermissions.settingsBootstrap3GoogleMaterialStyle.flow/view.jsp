<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<jcr:node var="sites" path="/sites"/>
<jcr:nodeProperty name="j:defaultSite" node="${sites}" var="defaultSite"/>
<c:set var="defaultPrepackagedSite" value="acmespace.zip"/>
<template:addResources type="javascript"
                       resources="jquery.min.js,jquery-ui.min.js,workInProgress.js"/>
<template:addResources type="css" resources="jquery-ui.smoothness.css,jquery-ui.smoothness-jahia.css,rolesmanager.css"/>
<jsp:useBean id="nowDate" class="java.util.Date"/>
<fmt:formatDate value="${nowDate}" pattern="yyyy-MM-dd-HH-mm" var="now"/>
<fmt:message key="label.workInProgressTitle" var="i18nWaiting"/><c:set var="i18nWaiting"
                                                                       value="${functions:escapeJavaScript(i18nWaiting)}"/>
<template:addResources>
    ${copiedRole}
    <script type="text/javascript">
        function getUuids() {
            var uuids = [];
            i = 0;
            $(".roleCheckbox:checked").each(function (index) {
                uuids[i++] = $(this).val();
            });
            return uuids;
        }

        var addRoleLabel = '<fmt:message key="rolesmanager.rolesAndPermissions.role.add" />';
        var addSubRoleLabel = '<fmt:message key="rolesmanager.rolesAndPermissions.subRole.add" />';

        function checkRole() {
            var uuids = getUuids();
            var roleTypeCombo = $('#roleTypeCombo');
            var deleteRolesButton = $('#deleteRolesButton');

            if (uuids.length == 1) {
                $('#addRoleButtonLabel').text(addSubRoleLabel);
                roleTypeCombo.val($("#" + uuids[0]).attr("roleType"));
                roleTypeCombo.prop("disabled", true);
                $('#uuid').val(uuids[0]);
            } else {
                $('#addRoleButtonLabel').text(addRoleLabel);
                roleTypeCombo.prop("disabled", false);
                $('#uuid').val('');
            }

            if (uuids.length == 0) {
                if (!deleteRolesButton.hasClass("disabled")) {
                    deleteRolesButton.addClass("disabled");
                    deleteRolesButton.attr("disabled", "disabled");
                }
            } else {
                if (deleteRolesButton.hasClass("disabled")) {
                    deleteRolesButton.removeClass("disabled");
                    deleteRolesButton.removeAttr("disabled");
                }
            }
        }

        function setRoleType() {
            $('#roleType').val($('#roleTypeCombo').val());
            return true;
        }

        function deleteRoles() {
            var uuids = getUuids();
            if (uuids.length == 0) {
                return false;
            }
            $('#uuid').val(uuids.join(","));
            $('#eventId').val('deleteRoles');
            $('#roleForm').submit();
        }

        function viewRole(uuid) {
            $('#uuid').val(uuid);
            $('#eventId').val('viewRole');
            $('#roleForm').submit();
        }

        function copyRole(uuid) {
            $('#uuid').val(uuid);
            $('#eventId').val('copyRole');
            $('#roleForm').submit();
        }
    </script>
</template:addResources>
<div class="page-header">
    <h2><fmt:message key="rolesmanager.rolesAndPermissions"/></h2>
</div>
<div class="panel panel-default panel-pdg">
<p>
<c:forEach var="msg" items="${flowRequestContext.messageContext.allMessages}">
    <div class="alert ${msg.severity == 'ERROR' ? 'validationError' : ''} ${msg.severity == 'ERROR' ? ' alert-danger' : ' alert-success'}">
        <button type="button" class="close" data-dismiss="alert">&times;</button>
            ${fn:escapeXml(msg.text)}
    </div>
</c:forEach>
</p>
<div>
    <fieldset>
        <form style="margin: 0;" action="${flowExecutionUrl}" method="POST" id="roleForm" class="form-inline"
              onsubmit="setRoleType()">
                <select id="roleTypeCombo" class="form-control">
                    <c:forEach items="${handler.roleTypes.values}" var="roleType">
                        <option value="${roleType.name}">
                            <fmt:message
                                    key="rolesmanager.rolesAndPermissions.roleType.${fn:replace(roleType.name,'-','_')}"/>
                        </option>
                    </c:forEach>
                </select>
                <input type="hidden" id="roleType" name="roleType"/>
                <fmt:message key="rolesmanager.rolesAndPermissions.role.add.name" var="addRoleLabel"/>
                <input type="text" id="addRoleField" class="form-control" name="newRole" placeholder="${addRoleLabel}"/>
                <input type="hidden" id="uuid" name="uuid"/>
                <input type="hidden" id="eventId" name="_eventId" value="addRole"/>
                <button class="btn btn-primary btn-align" type="submit">
                    <span id="addRoleButtonLabel"><fmt:message key="rolesmanager.rolesAndPermissions.role.add"/></span>
                </button>
                <button id="deleteRolesButton" class="btn btn-danger disabled btn-align" type="button"
                        onclick="deleteRoles()"
                        disabled="disabled">
                    <fmt:message key="rolesmanager.rolesAndPermissions.role.delete"/>
                </button>
        </form>
    </fieldset>
</div>

<fmt:message var="i18nCopy" key="label.copy"/><c:set var="i18nCopy" value="${fn:escapeXml(i18nCopy)}"/>
<c:forEach items="${roles}" var="entry" varStatus="loopStatus">
    <fieldset>

        <h3><fmt:message key="rolesmanager.rolesAndPermissions.roleType.${fn:replace(entry.key,'-','_')}"/></h3>

        <table class="table table-hover table-striped">
            <thead>
            <tr>
                <th width="3%">&nbsp;</th>
                <th width="25%">
                    <fmt:message key="label.name"/>
                </th>
                <th width="66%">
                    <fmt:message key="label.description"/>
                </th>
                <th width="6%">
                    <fmt:message key="label.actions"/>
                </th>
            </tr>
            </thead>

            <tbody>

            <c:forEach items="${entry.value}" var="role" varStatus="loopStatus2">
            <tr>
                <td>
                    <div class="checkbox">
                        <label>
                            <input id="${role.uuid}" name="selectedRoles" class="roleCheckbox" type="checkbox"
                                   value="${role.uuid}"
                                   roleType="${entry.key}" onchange="checkRole()"/>

                        </label>
                    </div>
                </td>
                <td>
                    <c:forEach var="i" begin="3" end="${role.depth}" step="1" varStatus="loopStatus3">
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    </c:forEach>
                    <strong><a href="#" onclick="viewRole('${role.uuid}')">${role.title} (${role.name})</a></strong>
                </td>
                <td>
                        ${role.description}
                </td>
                <td>
                       <button data-toggle="tooltip" data-placement="left" title="${i18nCopy}" class="btn btn-fab btn-fab-xs btn-info" type="button" onclick="copyRole('${role.uuid}');">
                           <i class="material-icons">content_copy</i>
                       </button>
                </td>
            </tr>
            </c:forEach>
    </div>
    </tbody>
    </table>

    </fieldset>
</c:forEach>
</div>
