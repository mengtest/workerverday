<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="java.util.List"%>
<%@page import="com.linewell.ucap.platform.cache.dbview.DbView"%>
<%@page import="com.linewell.ucap.admin.module.DbViewWrapper"%>
<%@include file="../include/session.jsp"%>
<%
/**
 * 根据模块unid，获取数据库视图列表
 * @author by cguangcong@linewell.com
 * @since 2011-12-22
 */
//获取业务模块标识 
String moduleUnid = request.getParameter("moduleUnid");
String appUnid = request.getParameter("appUnid");

//如果为空，则为非法访问，直接退出不做处理
if (StringUtils.isEmpty(appUnid)
        || StringUtils.isEmpty(moduleUnid)){
    return;
}	
List<DbView> dbViewList = DbViewWrapper.getComposeFormByModuleUnid(moduleUnid);
int dbViewCount = (null == dbViewList ? 0 : dbViewList.size());
%>  
<!DOCTYPE html>
<html>
  <head> 
    <meta content="text/html; charset=utf-8" http-equiv="Content-Type" />
    <title>数据库视图配置</title>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <style type="text/css"> </style>
	<link href="../module/style/stytle.css" rel="stylesheet" type="text/css" />
	<link href="../style/tip.css" rel="stylesheet" type="text/css" />
	<link href="../style/uploadPop.css" rel="stylesheet" type="text/css" />	
	<script language="javascript" src="<%= systemPath %>default/js/jquery-1.6.1.min.js"></script>
	<script language="javascript"  src="<%= systemPath %>default/js/jquery.cookie.js"></script>
	<script language="javascript" src="../default/js/linewell/linewell.core.js"></script>
	<script language="javascript" src="../js/common.js"></script>
	<script language="javascript"  src="../js/linewell.ucap.admin.settings.js"></script>
	<script language="javascript" src="../js/pageStep.js"></script>
	<script language="javascript" src="../js/jquery.tipHelp.js"></script>
	<%@include file="../include/platformresources.jsp"%>
  </head>
 <script type="text/javascript">
 /**
  * 刷新当前页面
  */
function refreshPage(){
	window.location.href = window.location.href;//刷新页面
}


//模拟试图的刷新，本页面之需要用到刷新本页   
var view={
   refresh:function(){
   	   refreshPage();
   },
   setGridHeight:function(){
   
   }
};
//模拟common.js中的参数
ucapCommonFun.ucapCurOpenType = 0;  
ucapCommonFun.autoMenuHeight = function(){};

//定义作为父窗口的事件集
var parentEvents = {}; 

//数据库视图的个数
var dbViewCount = <%= dbViewCount%>;

//定义jQuery为$开始
(function($){

var formUnid = "8CC35EB038BA68E929984A4676FDB15E";

var appUnid = "<%=appUnid%>";

//取消、删除按钮图标
var cancleIcon = "../module/style/images/common/cancel.png";

//取消图标的jQuery模板
var $cancleIconTemplate = $("<img src='" + cancleIcon + "'/>")    
    .addClass("cancleIcon");


/**
 * 根据unid打开数据库视图，当unid为空时为新建
 */

function openFormPage(unid){
	var formUrl = "<%= systemPath %>sys/jsp/document.jsp?unid="+unid+"&type=03&formId="
   					+ formUnid + "&viewMId=37A3E04F48EBC5C4E68C639D2EE230D7&openST=";											
   		formUrl+="&belongToAppId="+appUnid+"&belongToModuleId=<%=moduleUnid%>";
   	window.open(formUrl);  	
}
/**
 * 根据unid，删除数据库视图
 */
function deleteForm(unid){
	//获取数据库视图的链接
    var actionUrl = appPath + "BaseAction.action?type=getForm&act=delete";
    var postData ="{\"formUnid\": '2CD817D4D0416FFE9E22C02CA21AE204',\"formType\":\"01\",\"docUnid\":'"+unid+"',\"strResult\":\"\",\"isFlowItem\":false,\"belongToAppId\":'"+appUnid+"'}";  
	// 提交到后台
    $.ajax({
       type : "post",
       url : actionUrl,
       data : postData,
       dataType : "json",
       contentType : "application/json",
       async : false,
       success : function(data, textStatus) {       	            
          window.location.reload();
       },
       error : function() {                                           
           alert("加载数据库视图数据失败！");
       },
       statusCode : {// 处理错误状态
           404 : function() {
               alert("加载数据库视图数据失败！");
           }
       }
   });// end ajax
}
   
//页面加载完成的代码   
$(function(){

	/**
	 * 关闭上传的弹窗口
	 */    
	function closeUploadPop(){		
		$("#uploadPop").hide();
		window.location.href = window.location.href;
	}    
	
	//定义关闭事件
	parentEvents.close = closeUploadPop;
	
	/**
	 * 关闭弹出窗口
	 */
	$("#viewSelectCloseBtn").click(function(){
		closeUploadPop();
	});
	
	/**
	 * 根据unid打开数据库视图
	 */
	$(".formCfgBtn").click(function(){
		var $this = $(this);
		var unid = $this.attr("unid");
		openFormPage(unid);		
	});	
	
	/**
	 * 新建数据库视图
	 */
	$(".formAdd").click(function(){
		openFormPage("");
	});
	
	
	/**
	 * 改变状态
	 * @param isNormal 是否为正常状态
	 */
	function changeStatus(isNormal){    
	    if(!isNormal){       
	       $(".formCfgBtn").unbind("click");
	       $(".formCfgBtn").each(function(){
	           var $this = $(this);
	           var unid = $this.attr("unid");          
	           $cancleIcon = $cancleIconTemplate.clone();
	           $cancleIcon.click(function(){
	               if(confirm("此操作无法恢复！确定要删除选择的视图吗？")){
	                    deleteForm(unid);
	               }
	           });
	           $cancleIcon.appendTo($this);
	       });       
	       $("#formManage").val("取消");
	    }else{
	       $(".formCfgBtn").click(function(){
	           openFormPage($(this).attr("unid"));
	       });
	       $(".formCfgBtn .cancleIcon").remove();
	       $("#formManage").val("管理");       
	    }
	}
	
	/**
	 * 管理按钮的事件
	 */
	$(".formManage").click(function(){ 
	    var $moduleManage = $(this); 
	    if("管理" === $moduleManage.val()){
	       changeStatus(false);
		   $moduleManage.val("取消");
		}else{
		   changeStatus(true);
		   $moduleManage.val("管理");
		}
	});
	$("#tipDiv").tipHelp();
});//页面加载完成的代码 end
})(jQuery);//定义jQuery为$ end

  </script>
  <body>
  <div>
    <!-- 主区域 begin-->
	<div class="areaViewFormMain">
	<!-- 工具栏区域 -->
		<div class="formCfgToolBar">
			<h1>数据库视图列表</h1>
			<h2>共</h2>
			<h3><%= dbViewCount%></h3>
			<h2>个视图</h2>
			<input class="toolBarAdd formAdd" name="dbViewAdd" id="dbViewAdd"type="button" value="添加" title="添加据库视图" />
			<input class="toolBarMg formManage" name="dbViewManager" id="dbViewManager" type="button" value="管理" title="已有数据库视图删除管理" />
			<input class="toolBarRefresh" name="btnRefresh" id="btnRefresh" type="button" value="刷新" onclick="refreshPage()" title="刷新页面"/>
		</div>
	
		<!--按钮列表区域 begin-->
		<div class="formCfgBtns">
			<!--按钮项 -->
			<%
		   		if(null != dbViewList){
					for(DbView dbView:dbViewList){
			%>
		   	<div class="formCfgBtn" unid="<%=dbView.getUnid()%>">
				<img alt="" src="../module/style/images/module/designIcon_2.png" class="btnImg"/>
				<a><%=dbView.getNameCn()%></a>
			</div>	    
			<%}}%>		
		</div>
		<!--表单列表区域 end-->
	</div>
	<!-- 主区域 end-->
<div id="tipDiv">
　　通过添加、管理，对此模块下的数据库视图进行增加、删除。<br/>
<b>工具栏按钮功能说明：</b>
<ul>
	<li><b>添加：</b>单击进入按钮基本信息配置的页面</li>
	<li><b>管理：</b>进入按钮删除的状态</li>
</ul>
</div>
</div>
</body>
</html>
