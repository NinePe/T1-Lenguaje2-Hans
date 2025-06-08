<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Webapp</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { min-height: 100vh; }
        .sidebar { min-width: 220px; max-width: 220px; min-height: 100vh; }
        .tab-content { padding: 2rem; }
    </style>
</head>
<body>
<%
    String contentPage = (String) request.getAttribute("contentPage");
    if (contentPage != null) {
        RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/jsp/" + contentPage);
        rd.include(request, response);
    }
%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 