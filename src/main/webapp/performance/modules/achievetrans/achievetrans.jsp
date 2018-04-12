<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="s" uri="/struts-tags"%>

<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
</head>
<body>
<%
	response.setHeader( "Cache-Control", "no-cache,no-store");//HTTP 1.1
	response.setDateHeader( "Expires", 0 ); //prevent caching at the proxy server
	response.setHeader( "Pragma", "no-cache" );  //HTTP 1.0
%>
	<!-- datagrid -->
	<jsp:include page="../../../layout/center.jsp"></jsp:include>
	<jsp:include page="../../common/searchperson.jsp"></jsp:include>




	<!-- 论文表工具栏 -->
	<div id="tb">
		<a id="insert" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add', plain:true" onclick="append()">增加</a>
		<a id="del" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove', plain:true" onclick="removefunc()">删除</a>
		<a id="update" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-edit', plain:true" onclick="editfunc()">修改</a>
		<a id="lw_statusfilter" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-stutafilter', plain:true" onclick="achieveAdvancedSearch()">高级查询</a>
		<a id="import" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-impo', plain:true" onclick="importfunc()">导入</a>
	    <a id="export" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-export', plain:true" onclick="exportfunc()">导出</a>
	    <a id="refresh" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload', plain:true" onclick="refreshfunc()">刷新</a>
	    	    <a id="delAll" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-removeAll', plain:true" onclick="removeAll()">清空数据</a>
	    
	</div>

	
	<!-- 高级搜索 -->
	<div id="achieveAdvancedSearch_dialog" class="easyui-dialog" data-options="region:'north',title:'高级检索',buttons:'#advanced_search_btn',border:false,closed:true,modal:true"
		style="width:580px;height: 220px;padding-top:20px;padding-left:20px">
			<table class="altrowstable" cellspacing=”0″ cellpadding=”2″>
				<tr>
					<th>起始年度</th>
					<td><input id="achieve_begin_year" name="achieve_begin_year"  class="easyui-combobox" data-options="valueField:'id', textField:'text', width:'150px', editable:false" /></td>
					<th>终止年度</th>
					<td><input id="achieve_end_year" name="achieve_end_year"  class="easyui-combobox" data-options="valueField:'id', textField:'text', width:'150px', editable:false" /></td>
				</tr>
				<tr>
					<th>成果转化名称</th>
					<td><input type="text" id="achieve_lw_name" name="achieve_lw_name"  class="f1 easyui-textbox" data-options="width:'150px'"/></td>
					<th>成果人</th>
					<td><input type="text" id="achieve_lw_author" name="achieve_lw_author"  class="f1 easyui-textbox" data-options="width:'150px'"/></td>
				</tr>
				<tr>
					<th>成果人编号</th>
					<td><input type="text" id="achieve_lw_authorcode" name="achieve_lw_authorcode"  class="f1 easyui-textbox" data-options="width:'150px'"/></td>
				</tr>
			</table>
	</div>
	<div id="advanced_search_btn" >
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="adv_search_btn_ok()">搜索</a> 
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="adv_search_btn_cancel()">取消</a>
    </div>
	
	<!-- 添加-->
	<div id="admin_achieve_addDialog" class="easyui-dialog" data-options="region:'north',border:false, cache:false, closed:true,modal:true,title: '添加成果转化',modal: true,buttons:'#add_lw_btn'"
	 	style="width:705px;height: 512px;padding-top:8px;padding-left:20px">
		<form id="admin_achieve_addForm" method="post" enctype="multipart/form-data">
		<fieldset>
			<legend>成果转化信息</legend>
			<table class="altrowstable" cellspacing=”0″ cellpadding=”2″>
				<tr>
					<th>成果转化名称</th>
					<td colspan="3"><input id="add_achievename" name="name" class="easyui-textbox"
						data-options="required:true, prompt:'成果转化名称', width:'515px'" /></td>
				</tr>
				<tr>
					<th>成果转化号</th>
					<td ><input name="code" id="add_achievecode" class="easyui-textbox"  data-options="width:'200px'"/></td>
					<th>转化金额（万）</th>
					<td ><input name="achieveMoney" id="achieveMoney" class="easyui-numberbox" data-options="required:true,prompt:'转化金额（万）',width:'200px',missingMessage:'必须填写正数'"/></td>

				</tr>
				<tr>
					<th>转化年度</th>
					<td><input id="add_achieveyear" name="year" class="easyui-combobox"
						data-options="valueField:'id', textField:'text', required:true, prompt:'选择年份', width:'200px', editable:false" />
					</td>
					<!--
					<th>授权日期</th>
					<td><input name="date" id="add_achievedate" class="easyui-textbox"  data-options="width:'200px'"/></td>
				-->
				</tr>
				<!--
				<tr>
					<th>专利类别</th>
					<td><input name="type" id="add_type" class="easyui-textbox"  data-options="width:'200px'"/></td>
					<th>专利权人</th>
					<td><input name="owner" id="add_owner" class="easyui-textbox"  data-options="width:'200px'"/></td>
				</tr>
				<tr>
					<th>其他专利权</th>
					<td><input name="other" id="add_other" class="easyui-textbox"  data-options="width:'200px'"/></td>
					<th>单位排名</th>
					<td><input name="rank" id="add_rank" class="easyui-textbox"  data-options="width:'200px'"/></td>
				</tr>
				-->
			</table>
		</fieldset>
		<fieldset>
			<legend>成果转化人</legend>
			<table class="altrowstable" cellspacing=”0″ cellpadding=”2″>
				<tr>
					<th>成果人1</th>
					<td><input name="firstInvector" id="add_firstachieveInvector" class="easyui-textbox"  data-options="width:'200px'"/></td>
					<th>成果人2</th>
					<td><input name="secondInvector" id="add_secondachieveInvector" class="easyui-textbox"  data-options="width:'200px'"/></td>
				</tr>
				<tr>
					<th>成果人3</th>
					<td><input name="thirdInvector" id="add_thirdachieveInvector" class="easyui-textbox"  data-options="width:'200px'"/></td>
					<th>成果人4</th>
					<td><input name="fourthInvector" id="add_fourthachieveInvector" class="easyui-textbox"  data-options="width:'200px'"/></td>
				</tr>
				<tr>
					<th>成果人5</th>
					<td><input name="fifthInvector" id="add_fifthachieveInvector" class="easyui-textbox"  data-options="width:'200px'"/></td>
					<th>其他成果人</th>
					<td><input name="otherInvector" id="add_otherachieveInvector" class="easyui-textbox"  data-options="width:'200px'"/></td>
				</tr>
			</table>
		</fieldset>
		
		<input type="hidden" name="firstInvectorcode" id="add_firstachieveInvectorcode">
		<input type="hidden" name="secondInvectorcode" id="add_secondachieveInvectorcode">
		<input type="hidden" name="thirdInvectorcode" id="add_thirdachieveInvectorcode">
		<input type="hidden" name="fourthInvectorcode" id="add_fourthachieveInvectorcode">
		<input type="hidden" name="fifthInvectorcode" id="add_fifthachieveInvectorcode">
		<input type="hidden" name="otherInvectorcode" id="add_otherachieveInvectorcode">
		
		</form>
    </div>
    <div id="add_lw_btn" >
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="add_achieve_btn_ok()">保存</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="add_achieve_btn_cancel()">取消</a>
    </div>
    
	<!-- 编辑专利 -->
	<div id="admin_achieve_editDialog" class="easyui-dialog" data-options="region:'north',border:false, cache:false, closed:true,modal:true,title:'编辑成果转化',modal:true,buttons:'#edit_lw_btn'"
	 	style="width:705px;height: 512px;padding-top:20px;padding-left:20px">
	<form id="admin_achieve_editForm" method="post" enctype="multipart/form-data">
		<fieldset>
			<legend>成果转化信息</legend>
			<table class="altrowstable" cellspacing=”0″ cellpadding=”2″>
				<tr>
					<th>成果转化名称</th>
					<td colspan="3"><input id="e_achievename" name="name" class="easyui-textbox"
						data-options="required:true, prompt:'成果转化名称', width:'515px'" /></td>
				</tr>
				<tr>
					<th>成果转化号</th>
					<td ><input name="code" id="e_achievecode" class="easyui-textbox"  data-options="width:'200px'"/></td>
					<th>转化金额</th>
					<td ><input name="achieveMoney" id="e_achieveMoney" class="easyui-numberbox"  data-options="required:true,prompt:'转化金额（万）',width:'200px',missingMessage:'必须填写正数'"/></td>

				</tr>
				<tr>
					<th>转化年度</th>
					<td><input id="e_achieveyear" name="year" class="easyui-combobox"
						data-options="valueField:'id', textField:'text', required:true, prompt:'选择年份', width:'200px', editable:false" />
					</td>
					<!--
					<th>授权日期</th>
					<td><input name="date" id="e_achievedate" class="easyui-textbox"  data-options="width:'200px'"/></td>
			-->
				</tr>
				<!--
				<tr>
					<th>专利类别</th>
					<td><input name="type" id="e_type" class="easyui-textbox"  data-options="width:'200px'"/></td>
					<th>专利权人</th>
					<td><input name="owner" id="e_owner" class="easyui-textbox"  data-options="width:'200px'"/></td>
				</tr>
				<tr>
					<th>其他专利权</th>
					<td><input name="other" id="e_other" class="easyui-textbox"  data-options="width:'200px'"/></td>
					<th>单位排名</th>
					<td><input name="rank" id="e_rank" class="easyui-textbox"  data-options="width:'200px'"/></td>
				</tr>
				-->
			</table>
		</fieldset>
		<fieldset>
			<legend>成果人</legend>
			<table class="altrowstable" cellspacing=”0″ cellpadding=”2″>
				<tr>
					<th>成果人1</th>
					<td><input name="firstInvector" id="e_firstachieveInvector" class="easyui-textbox"  data-options="width:'200px'"/></td>
					<th>成果人2</th>
					<td><input name="secondInvector" id="e_secondachieveInvector" class="easyui-textbox"  data-options="width:'200px'"/></td>
				</tr>
				<tr>
					<th>成果人3</th>
					<td><input name="thirdInvector" id="e_thirdachieveInvector" class="easyui-textbox"  data-options="width:'200px'"/></td>
					<th>成果人4</th>
					<td><input name="fourthInvector" id="e_fourthachieveInvector" class="easyui-textbox"  data-options="width:'200px'"/></td>
				</tr>
				<tr>
					<th>成果人5</th>
					<td><input name="fifthInvector" id="e_fifthachieveInvector" class="easyui-textbox"  data-options="width:'200px'"/></td>
					<th>其他成果人</th>
					<td><input name="otherInvector" id="e_otherachieveInvector" class="easyui-textbox"  data-options="width:'200px'"/></td>
				</tr>
			</table>
		</fieldset>
		
		<input type="hidden" name="firstInvectorcode" id="e_firstachieveInvectorcode">
		<input type="hidden" name="secondInvectorcode" id="e_secondachieveInvectorcode">
		<input type="hidden" name="thirdInvectorcode" id="e_thirdachieveInvectorcode">
		<input type="hidden" name="fourthInvectorcode" id="e_fourthachieveInvectorcode">
		<input type="hidden" name="fifthInvectorcode" id="e_fifthachieveInvectorcode">
		<input type="hidden" name="otherInvectorcode" id="e_otherachieveInvectorcode">
		<input type="hidden" name="id" id="e_achieveid" />
	</form>
	</div>

	<div id="edit_lw_btn" >
    	<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="edit_achieve_btn_ok()">保存</a>
    	<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="edit_achieve_btn_cancel()">取消</a>
	</div>

	<div id="import_achieve" class="easyui-dialog" data-options="region:'north',border:false, cache:false, closed:true,modal:true,title: '导入成果转化',modal: true,buttons:'#import_lw_btn'"
	 	style="width:400px;height: 250px;padding-top:20px;padding-left:20px">
		<form id="admin_thesis_importForm" method="post" enctype="multipart/form-data">
	<table>
		<tr>
		<th>附件</th>
		<td><input type="file" name="upload" id="achieve_import"></td>
		</tr>
	</table>
	</form>
	</div>
	<div id="#import_lw_btn" >
    	<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="editlw_btn_ok()">保存</a> 
    	<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="editlw_btn_cancel()">取消</a>
	</div>

	<!-- 论下载对话框  -->
	<div id="export_lw" class="easyui-dialog" data-options="region:'north',border:false, cache:false, closed:true,modal:true,title: '成果转化导出',modal: true,buttons:'#export_lw_btn'"
	 	style="width:620px;height: 500px;padding-top:20px;padding-left:20px">
		<form id="admin_thesis_exportForm" method="post" enctype="multipart/form-data">
			<table>
				<tr>
					<th>附件</th>
					<td><input type="file" name="upload" id="achieve_export"></td>
				</tr>
			</table>
		</form>
	</div>
	<div id="#export_lw_btn" >
    	<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="exportlw_btn_ok()">保存</a> 
    	<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="exportlw_btn_cancel()">取消</a>
	</div>
	
</body>
</html>