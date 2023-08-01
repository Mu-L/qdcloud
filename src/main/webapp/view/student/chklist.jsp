<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
String subpage = "studentlist";
%>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/left.jsp" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>

<head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
	<meta charset="utf-8">
	<title><%=title%></title>
	<meta name="description" content="">
	<meta name="author" content="">
	<!--[if lt IE 9]>
    <script src="js/html5.js"></script>
    <script src="js/css3-mediaqueries.js"></script>
    <![endif]-->
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/cloud-admin.css" >
	<link rel="stylesheet" type="text/css"  href="${pageContext.request.contextPath}/css/themes/night.min.css" id="skin-switcher" >
	<link rel="stylesheet" type="text/css"  href="${pageContext.request.contextPath}/css/responsive.css" >
	<!-- FONTS -->
	<link href="${pageContext.request.contextPath}/font-awesome/css/font-awesome.min.css" rel="stylesheet">
	<!-- ANIMATE -->
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/animatecss/animate.min.css" />	
</head>
<body>
<!--#include virtual="/BIsystem/include/header.html"-->
	
	<!-- PAGE -->
	<section id="page" data-page="student" sub-page="studentlist">
		<!--#include virtual="/BIsystem/include/side.html"-->
		<div id="main-content">
			<div class="container">
				<div class="row">
					<div id="content" class="col-lg-12">
						<!-- PAGE HEADER-->
						<div class="row">
                            <div class="col-sm-12">
                                <div class="page-header">
                                    <!-- BREADCRUMBS -->
                                    <ul class="breadcrumb pull-left">
                                        <li>
                                            <i class="fa fa-home"></i>
                                            <a href="/view/message/msgadminlist.jsp">Home</a>
                                        </li>
                                        <li>学生列表</li>
                                    </ul>
                                    <div class="pull-right mt10 ml10 hui999">当前时间：<span class="hui666"><%=date %></span></div>
                                    <div class="pull-right mt10 hui999">登录人：<span class="blue"><%=real_name %></span></div>
                                    <!-- /BREADCRUMBS -->

                                </div>
                            </div>
                        </div>
						<div class="content-in pos-r">
                        <div class="s-pannel mt20">
                        	
							<div role="form" class="form-inline " style="width:1050px;">
                              <div class="form-group mr15">
                              	<select class="form-control w160" id="class_name">
                                  <option value="">-选择班级-</option>
                                </select>
                              </div>
                             
                              <button class="btn btn-primary mr10" id="serach"><i class="fa fa-search fa-fw"></i>搜索</button>
                            </div>
                            
                           
                            </div>
                            <div class="t-wrap mt20">
                            	<table class="table table-bordered table-striped center">
                                    <thead>
                                      <tr>
                                        <th width="15%">学号</th>
                                        <th width="10%">姓名</th>
                                        <th width="10%">班级</th>
                                        <th width="20%">时间</th>
                                        <th width="40%">操作</th>
                                      </tr>
                                    </thead>
                                    <tbody id="datatable">

                                	</tbody>
                                  </table>
                            </div>
                            <jsp:include page="../common/page.jsp"/>
						</div>
						<!-- /PAGE HEADER -->
					</div><!-- /CONTENT-->
				</div>
			</div>
		</div>
	</section>
	<!--/PAGE -->
	<!-- JAVASCRIPTS -->
	<!-- Placed at the end of the document so the pages load faster -->
	<!-- JQUERY -->
	<script src="${pageContext.request.contextPath}/js/jquery/jquery-2.0.3.min.js"></script>
	<!-- BOOTSTRAP -->
	<script src="${pageContext.request.contextPath}/bootstrap-dist/js/bootstrap.min.js"></script>	
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/jQuery-slimScroll-1.3.0/jquery.slimscroll.min.js"></script>
	<!-- CUSTOM SCRIPT -->
	<script src="${pageContext.request.contextPath}/js/script.js"></script>

	<script type="text/javascript" src="${pageContext.request.contextPath}/js/xco.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/public.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-xco-src.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jqPaginator.js"></script>
	<script>
		jQuery(document).ready(function() {	
			App.init(); //Initialise plugins and elements
		});
		
		$(function(){
			$("#serach").click(function(){
				renderPage = true;
				doSubmit(0,pageSize);
			});
			
		})
		
		 //分页查询表格
		doSubmit(0,pageSize); 	
		
		initClass("class_name",'');
    		
		var renderPage = true;
		function doSubmit(start,pageSize){
   			var class_id = $("#class_name").val();
			
			//传分页条件
  			var options ={
					url: "/cgi-bin/chkstudent.sh?class_id=" + class_id,
					data: new XCO(),
					success: manage
			};
			$.doXcoRequest(options);					
		}
        
		function manage(xco){
			var total = 0;
			if(xco.getIntegerValue("total")){
				total = xco.getIntegerValue("total");
			}
            		var _dataList = xco.getXCOListValue("data");
            		var tdIndex = 1;
            		$("#datatable").html("");
            		if(_dataList){
				var tdIndex = 1;
				for ( var i = 0; i < _dataList.length; i++) {
					$("#datatable").append('<tr>'
							+'<td>'+_dataList[i].getObjectValue("user_name")+'</td>'
							+'<td>'+_dataList[i].getObjectValue("real_name")+'</td>'
							+'<td>'+_dataList[i].getObjectValue("class_name")+'</td>'
							+'<td>'+_dataList[i].getObjectValue("time")+'</td>'
							+'<td>'+checkUrl(_dataList[i].getObjectValue("user_id"), _dataList[i].getObjectValue("state"))+'</td>'
							+'</tr>')
				}
			}
            		if(renderPage){
            			renderPage = false;
            			pageUtil('pagination_1', parseInt(total), doSubmit, pageSize);                    	
            		}
			
		}  
		
		function checkUrl(user_id, state){
			dovmurl = "<a href=\"/cgi-bin/studentcheck.sh?";
                        vmparam = dovmurl + "user_id=<%=user_id%>&action=normal\">签到</a>&nbsp;&nbsp;&nbsp;" + 
			          dovmurl + "user_id=<%=user_id%>&action=delay\">迟到</a>&nbsp;&nbsp;&nbsp;" +
			          dovmurl + "user_id=<%=user_id%>&action=leave\">旷课</a>&nbsp;&nbsp;&nbsp;" +
			          dovmurl + "user_id=<%=user_id%>&action=thing\">事假</a>&nbsp;&nbsp;&nbsp;" +
			          dovmurl + "user_id=<%=user_id%>&action=ill\">病假</a>&nbsp;&nbsp;&nbsp;";
			return vmparam;
		}
		
	</script>
	<!-- /JAVASCRIPTS -->	
</body>
</html>
