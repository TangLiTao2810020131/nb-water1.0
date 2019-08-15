<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<base href="<%=basePath%>">
<title>小区户操作页面</title>
<meta name="renderer" content="webkit">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
<link rel="stylesheet"
	href="${ctx}/resources/plugins/layui/css/layui.css" media="all">
<link rel="stylesheet" href="${ctx}/resources/css/admin.css" media="all">
<link rel="stylesheet"
	href="${ctx}/resources/plugins/zTree_v3/css/zTreeStyle/zTreeStyle.css"
	type="text/css">
<link rel="stylesheet" href="${ctx}/resources/css/addClass.css"
	media="all" />
<style type="text/css">
.layui-form-label {
	width: 90px;
}

.layui-input-block {
	margin-left: 120px;
}
</style>
</head>

<body>
	<div class="layui-bg-white">
		<div class="layui-fluid">
			<div class="layui-row  layui-col-space15">
				<fieldset class="layui-elem-field layui-field-title"
					style="margin-top: 12px;">
					<legend>${residential.province }-${residential.city}-${residential.area}-${residential.name}-${build.building}栋</legend>
				</fieldset>
				<form class="layui-form" method="post">
					<input type="hidden" name="id" value="${door.id }" />
					<input type="hidden" name="buildingid" value="${door.buildingid }" />


					<div class="layui-form-item">
						<label class="layui-form-label">门牌号:</label>
						<div class="layui-input-block">
							<input type="text" name="doornum" id="doornum"
								value="${door.doornum }" lay-verify="title"
								autocomplete="off" placeholder="请输入门牌号" class="layui-input">
						</div>
					</div>

					<div class="layui-form-item layui-form-text">
						<label class="layui-form-label">描述</label>
						<div class="layui-input-block">
							<textarea placeholder="请输入内容" name="describe" id="describe"
								style="resize:none" class="layui-textarea">${door.describe }</textarea>
						</div>
					</div>

					<div class="layui-form-item">
						<div class="layui-input-block">
							<button type="button" class="layui-btn" id="demo1"
								lay-filter="demo1">提交</button>
						</div>
					</div>

				</form>
			</div>
		</div>
	</div>
</body>
<script src="${ctx}/resources/js/layui.all.js"></script>
<script src="${ctx}/resources/js/jquery-1.11.2.min.js"></script>
<script src="${ctx}/resources/plugins/layui/layui.js"></script>
<script src="${ctx}/resources/js/formatTime.js"></script>
<script
	src="${ctx}/resources/plugins/zTree_v3/js/jquery.ztree.all-3.5.min.js"></script>
<script type="text/javascript">

	$(function() {
		$("#code").focus();
    }); 

    //楼栋号唯一性验证
    function isCheckDoor(data){
        var num;
        $.ajax({
            type : "POST", //提交方式
            url : "${ctx}/door/isCheckDoor.action", //路径
            data : data, //数据，这里使用的是Json格式进行传输
            dataType : "json",
            async : false,
            success : function(result) { //返回数据根据结果进行相应的处理
                num = result;
            }
        });
        return num;
    } 

	//点击登录按钮触发登录验证方法
	$("#demo1").click(function() {
	
		$("#demo1").attr('disabled', true); //设置提交禁用防止重复提交数据
		
		var doornum = $("#doornum").val();

		if (doornum == ""|| doornum == null) {
			layer.msg('请输入门牌号！', {
				icon : 7,
				time : 2000 //2秒关闭（如果不配置，默认是3秒）
			}, function() {
				$("#doornum").focus();
				$("#demo1").attr('disabled', false);
			});
			return;
		}
		var data = $("form").serialize();
		var num = isCheckDoor(data);
        if(num != 0 && num != -1){
            layer.msg('该栋已存在此门牌号,请重新输入！', {
                icon : 7,
                time : 2000 //2秒关闭（如果不配置，默认是3秒）
            }, function() {
                $("#doornum").focus();
                $("#demo1").attr('disabled', false);
            });
            return;
        }		
		$.ajax({
			type : "POST", //提交方式 
			url : "${ctx}/door/save.action", //路径 
			data : data, //数据，这里使用的是Json格式进行传输 
			dataType : "json",
			async : false,
			success : function(result) { //返回数据根据结果进行相应的处理
				console.log(result);
				var status = result.status;
				var msg = result.msg;
				layer.msg(msg, {
					icon : 1,
					time : 2000 //2秒关闭（如果不配置，默认是3秒）
				}, function() {
					layer.close(layer.index);
					window.parent.location.reload();
				});
			},
			error : function(result) {
				layer.msg("操作失败,请选择管理员!", {
					icon : 1,
					time : 2000 //2秒关闭（如果不配置，默认是3秒）
				}, function() {
					layer.close(layer.index);
					window.parent.location.reload();
				});
			}
		});
		return false;
	});
</script>
</html>
