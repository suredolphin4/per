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

	<input type=hidden id="contextPath"
		value="${pageContext.request.contextPath}" />


	<!-- 论文表工具栏 -->
	<div id="tb">
		<a id="insert" href="javascript:void(0)" class="easyui-linkbutton"
			data-options="iconCls:'icon-add', plain:true" onclick="append()">增加</a>
		<a id="del" href="javascript:void(0)" class="easyui-linkbutton"
			data-options="iconCls:'icon-remove', plain:true"
			onclick="removedtfunc()">删除</a> <a id="update"
			href="javascript:void(0)" class="easyui-linkbutton"
			data-options="iconCls:'icon-edit', plain:true" onclick="editdtfunc()">修改/查看</a>
		<a id="sub" href="javascript:void(0)" class="easyui-linkbutton"
			data-options="iconCls:'icon-submit', plain:true"
			onclick="submitfunc()">提交</a>
		<a id="revoke" href="javascript:void(0)" class="easyui-linkbutton"
			data-options="iconCls:'icon-undo', plain:true"
			onclick="revokefunc()">撤回</a> 
		<a id="audit" href="javascript:void(0)"
			class="easyui-linkbutton"
			data-options="iconCls:'icon-audit', plain:true" onclick="auditfunc()">审核</a>
		<a id="dt_statusfilter" href="javascript:void(0)"
			class="easyui-linkbutton"
			data-options="iconCls:'icon-stutafilter', plain:true"
			onclick="advancedSearch()">高级查询</a> <input id="audit_filter"
			name="audit_filter" class="easyui-combobox"
			data-options="width:'100px', editable:false, valueField:'id', textField:'value', data:[{id:'全部', value:'全部', selected:true},{id:'已保存', value:'已保存'},{id:'已提交', value:'已提交'},{id:'审核通过', value:'审核通过'},{id:'已退回', value:'已退回'}]" />
		<a id="import" href="javascript:void(0)" class="easyui-linkbutton"
			data-options="iconCls:'icon-impo', plain:true" onclick="importfunc()">导入</a>
		<a id="export" href="javascript:void(0)" class="easyui-linkbutton"
			data-options="iconCls:'icon-export', plain:true"
			onclick="exportfunc()">导出</a> <a id="refresh"
			href="javascript:void(0)" class="easyui-linkbutton"
			data-options="iconCls:'icon-reload', plain:true"
			onclick="refreshfunc()">刷新</a>
	</div>


	<!-- 高级搜索 -->
	<div id="advancedSearch_dialog" class="easyui-dialog"
		data-options="region:'north',title:'高级检索',buttons:'#advanced_search_btn',border:false,closed:true,modal:true"
		style="width: 580px;height: 220px;padding-top:20px;padding-left:20px">
		<table class="altrowstable" cellspacing=”0″ cellpadding=”2″>
			<tr>
				<th>起始年度</th>
				<td><input id="s_begin_year" name="s_begin_year"
					class="easyui-combobox"
					data-options="valueField:'id', textField:'text', width:'150px', editable:false" /></td>
				<th>终止年度</th>
				<td><input id="s_end_year" name="s_end_year"
					class="easyui-combobox"
					data-options="valueField:'id', textField:'text', width:'150px', editable:false" /></td>
			</tr>
			<tr>
				<th>地图名称</th>
				<td><input type="text" id="s_lw_name" name="s_lw_name"
					class="f1 easyui-textbox" data-options="width:'150px'" /></td>
				<th>主编与编辑</th>
				<td><input type="text" id="s_lw_author" name="s_lw_author"
					class="f1 easyui-textbox" data-options="width:'150px'" /></td>
			</tr>
			<tr>
				<th>主编编辑编号</th>
				<td><input type="text" id="s_lw_authorcode" name="s_lw_authorcode"
						   class="f1 easyui-textbox" data-options="width:'150px'" /></td>
			</tr>
		</table>
	</div>
	<div id="advanced_search_btn">
		<a href="javascript:void(0)" class="easyui-linkbutton"
			iconCls="icon-ok" onclick="adv_search_btn_ok()">搜索</a> <a
			href="javascript:void(0)" class="easyui-linkbutton"
			iconCls="icon-cancel" onclick="adv_search_btn_cancel()">取消</a>
	</div>

	<!-- 添加 -->
	<div id="admin_map_addDialog" class="easyui-dialog"
		data-options="region:'north',border:false, cache:false, closed:true,modal:true,title: '增加地图',modal: true,buttons:'#add_dt_btn'"
		style="width:705px;height: 600px;padding-top:8px;padding-left:20px">
		<form id="admin_map_addForm" method="post"
			enctype="multipart/form-data">
			<fieldset>
				<legend>地图信息</legend>
				<table class="altrowstable" cellspacing=”0″ cellpadding=”2″>
					<tr>
						<th>地图名称</th>
						<td colspan="3"><input id="dt_title" name="title"
							class="easyui-textbox"
							data-options="required:true, prompt:'请填写地图名称', width:'515px'" /></td>
					</tr>
					<tr>
						<th>年度</th>
						<td><input id="dt_year" name="year" class="easyui-combobox"
							data-options="valueField:'id', textField:'text', required:true, prompt:'请选择年度', width:'200px', editable:false" />
						</td>
						<th>总页数</th>
						<td><input id="dt_totalpage" name="totalpage"
							class="easyui-numberbox" min="0"  precision="0" missingMessage="必须填写正整数"
							data-options="required:true, prompt:'请填写总页数', width:'200px'" /></td>
					</tr>
					<tr>
						<th>地图类型</th>
						<td><select name="maptype" id="dt_maptype"
							class="easyui-combobox"
							data-options="required:true, prompt:'请选择地图类别', width:'200px',editable:false, valueField: 'label',
					textField: 'value', data:[{label:'纸质版国家地图集' ,value:'纸质版国家地图集'}, {label:'纸质版区域地图集', value:'纸质版区域地图集'}, {label:'其他纸质版地图集' ,value:'其他纸质版地图集'},{label:'国家电子地图集', value:'国家电子地图集'},
					{label:'区域电子地图集' ,value:'区域电子地图集'},{label:'扫描版电子地图集' ,value:'扫描版电子地图集'},{label:'2个A0幅面出版挂图' ,value:'2个A0幅面出版挂图'},{label:'1个A0幅面出版挂图' ,value:'1个A0幅面出版挂图'}, {label:'A3-A0幅面出版挂图', value:'A3-A0幅面出版挂图'}]"></select></td>
					</tr>
				</table>
			</fieldset>
			<fieldset>
				<legend>主编</legend>
				<table class="altrowstable" cellspacing=”0″ cellpadding=”2″>
					<tr>
						<th>主编1</th>
						<td><input name="firsteditor" id="dt_firsteditor"
							class="easyui-textbox"
							data-options="width:'200px', required:true" readonly="readonly"/></td>
						<th>主编2</th>
						<td><input name="seceditor" id="dt_seceditor"
							class="easyui-textbox" data-options="width:'200px'" readonly="readonly"/></td>
					</tr>
					<tr>
						<th>主编3</th>
						<td><input name="thirdeditor" id="dt_thirdeditor"
							class="easyui-textbox" data-options="width:'200px'" readonly="readonly"/></td>
						<th>其他主编</th>
						<td><input name="othereditor" id="dt_othereditor"
							class="easyui-textbox" data-options="width:'200px'" readonly="readonly"/></td>
					</tr>
				</table>
			</fieldset>
			<fieldset>
				<legend>副主编</legend>
				<table class="altrowstable" cellspacing=”0″ cellpadding=”2″>
					<tr>
						<th>副主编1</th>
						<td><input name="firstsubeditor" id="dt_firstsubeditor"
							class="easyui-textbox" data-options="width:'200px'" readonly="readonly"/></td>
						<th>副主编2</th>
						<td><input name="secsubeditor" id="dt_secsubeditor"
							class="easyui-textbox" data-options="width:'200px'" readonly="readonly"/></td>
					</tr>
					<tr>
						<th>副主编3</th>
						<td><input name="thirdsubeditor" id="dt_thirdsubeditor"
							class="easyui-textbox" data-options="width:'200px'" readonly="readonly"/></td>
						<th>其他副主编</th>
						<td><input name="othersubeditor" id="dt_othersubeditor"
							class="easyui-textbox" data-options="width:'200px'" readonly="readonly"/></td>
					</tr>
				</table>
			</fieldset>
			<fieldset>
				<legend>编辑</legend>
				<table class="altrowstable" cellspacing=”0″ cellpadding=”2″>
					<tr>
						<th>编辑1</th>
						<td><input name="firstauthor" id="dt_firstauthor"
							class="easyui-textbox" data-options="width:'200px'" readonly="readonly"/></td>
						<th>编辑2</th>
						<td><input name="secauthor" id="dt_secauthor"
							class="easyui-textbox" data-options="width:'200px'" readonly="readonly"/></td>
					</tr>
					<tr>
						<th>编辑3</th>
						<td><input name="threeauthor" id="dt_threeauthor"
							class="easyui-textbox" data-options="width:'200px'" readonly="readonly"/></td>
						<th>编辑4</th>
						<td><input name="fourauthor" id="dt_fourauthor"
							class="easyui-textbox" data-options="width:'200px'"
							onclick="seachObjauthor()" readonly="readonly"/></td>
					</tr>
					<tr>

						<th>编辑5</th>
						<td><input name="fiveauthor" id="dt_fiveauthor"
							class="easyui-textbox" data-options="width:'200px'"
							onclick="seachObjauthor()" readonly="readonly"/></td>
						<th>其他编辑</th>
						<td><input name="otherauthor" id="dt_otherauthor"
							class="easyui-textbox" data-options="width:'200px'" readonly="readonly"/></td>
					</tr>
				</table>
			</fieldset>
			<fieldset>
				<legend>附件</legend>
				<table class="altrowstable" cellspacing=”0″ cellpadding=”2″>
					<tr>
						<th>附件</th>
						<td colspan="3"><input type="file" name="upload"
							id="dt_upload" /></td>
					</tr>
				</table>
			</fieldset>
			<input type="hidden" name="firsteditorcode" id="dt_firsteditorcode" />
			<input type="hidden" name="seceditorcode" id="dt_seceditorcode" /> 
			<input type="hidden" name="thirdeditorcode" id="dt_thirdeditorcode" /> 
			<input type="hidden" name="othereditorcode" id="dt_othereditorcode" /> 
			<input type="hidden" name="firstsubeditorcode" id="dt_firstsubeditorcode" />
			<input type="hidden" name="secsubeditorcode" id="dt_secsubeditorcode" />
			<input type="hidden" name="thirdsubeditorcode" id="dt_thirdsubeditorcode" /> 
			<input type="hidden" name="othersubeditorcode" id="dt_othersubeditorcode" /> 
			<input type="hidden" name="firstauthorcode" id="dt_firstauthorcode" /> 
			<input type="hidden" name="secauthorcode" id="dt_secauthorcode" /> 
			<input type="hidden" name="threeauthorcode" id="dt_threeauthorcode" /> 
			<input type="hidden" name="fourauthorcode" id="dt_fourauthorcode" /> 
			<input type="hidden" name="fiveauthorcode" id="dt_fiveauthorcode" /> 
			<input type="hidden" name="otherauthorcode" id="dt_otherauthorcode" /> 
			<input type="hidden" name="examinestatus" id="auditstatus" />
			<input type="hidden" name="append" id="dt_add_append" />
			</table>
		</form>
	</div>
	<div id="add_dt_btn">
		<a href="javascript:void(0)" class="easyui-linkbutton"
			iconCls="icon-ok" onclick="adddt_btn_ok()">保存</a> <a
			href="javascript:void(0)" class="easyui-linkbutton"
			iconCls="icon-cancel" onclick="adddt_btn_cancel()">取消</a>
	</div>

	<!-- 编辑 -->
	<div id="admin_map_editDialog" class="easyui-dialog"
		data-options="region:'north',border:false, cache:false, closed:true,modal:true,title:'编辑地图',modal:true,buttons:'#edit_dt_btn'"
		style="width:705px;height: 600px;padding-top:8px;padding-left:20px">
		<form id="admin_map_editForm" method="post"
			enctype="multipart/form-data">
			<fieldset>
				<legend>地图信息</legend>
				<table class="altrowstable" cellspacing=”0″ cellpadding=”2″>
					<tr>
						<th>地图名称</th>
						<td colspan="3"><input id="e_dt_title" name="title"
							class="easyui-textbox"
							data-options="required:true, prompt:'请填写地图名称', width:'515px'" /></td>

					</tr>
					<tr>
						<th>年度</th>
						<td><input id="e_dt_year" name="year" class="easyui-combobox"
							data-options="valueField:'id', textField:'text', required:true, prompt:'请选择年度', width:'200px', editable:false" />
						</td>
						<th>总页数</th>
						<td><input id="e_dt_totalpage" name="totalpage"
							class="easyui-textbox"
							data-options="required:true, prompt:'请填写总页数', width:'200px'" /></td>
					</tr>
					<tr>
						<th>地图类型</th>
						<td><select name="maptype" id="e_dt_maptype"
							class="easyui-combobox"
							data-options="required:true, prompt:'请选择地图类别', width:'200px',editable:false, valueField: 'label',
					textField: 'value', data:[{label:'纸质版国家地图集' ,value:'纸质版国家地图集'}, {label:'纸质版区域地图集', value:'纸质版区域地图集'}, {label:'其他纸质版地图集' ,value:'其他纸质版地图集'},{label:'国家电子地图集', value:'国家电子地图集'},
					{label:'区域电子地图集' ,value:'区域电子地图集'},{label:'扫描版电子地图集' ,value:'扫描版电子地图集'},{label:'2个A0幅面出版挂图' ,value:'2个A0幅面出版挂图'},{label:'1个A0幅面出版挂图' ,value:'1个A0幅面出版挂图'}, {label:'A3-A0幅面出版挂图', value:'A3-A0幅面出版挂图'}]"></select></td>

					</tr>
				</table>
			</fieldset>
			<fieldset>
				<legend>主编</legend>
				<table class="altrowstable" cellspacing=”0″ cellpadding=”2″>
					<tr>
						<th>主编1</th>
						<td><input name="firsteditor" id="e_dt_firsteditor"
							class="easyui-textbox"
							data-options="width:'200px', required:true" readonly="readonly"/></td>

						<th>主编2</th>
						<td><input name="seceditor" id="e_dt_seceditor"
							class="easyui-textbox" data-options="width:'200px'" readonly="readonly"/></td>
					</tr>

					<tr>
						<th>主编3</th>
						<td><input name="thirdeditor" id="e_dt_thirdeditor"
							class="easyui-textbox" data-options="width:'200px'" readonly="readonly"/></td>

						<th>其他主编</th>
						<td><input name="othereditor" id="e_dt_othereditor"
							class="easyui-textbox" data-options="width:'200px'" readonly="readonly"/></td>
					</tr>
				</table>
			</fieldset>
			<fieldset>
				<legend>副主编</legend>
				<table class="altrowstable" cellspacing=”0″ cellpadding=”2″>
					<tr>
						<th>副主编1</th>
						<td><input name="firstsubeditor" id="e_dt_firstsubeditor"
							class="easyui-textbox" data-options="width:'200px'" readonly="readonly"/></td>

						<th>副主编2</th>
						<td><input name="secsubeditor" id="e_dt_secsubeditor"
							class="easyui-textbox" data-options="width:'200px'" readonly="readonly"/></td>
					</tr>

					<tr>
						<th>副主编3</th>
						<td><input name="thirdsubeditor" id="e_dt_thirdsubeditor"
							class="easyui-textbox" data-options="width:'200px'" readonly="readonly"/></td>

						<th>其他副主编</th>
						<td><input name="othersubeditor" id="e_dt_othersubeditor"
							class="easyui-textbox" data-options="width:'200px'" readonly="readonly"/></td>
					</tr>
				</table>
			</fieldset>
			<fieldset>
				<legend>编辑</legend>
				<table class="altrowstable" cellspacing=”0″ cellpadding=”2″>
					<tr>
						<th>编辑1</th>
						<td><input name="firstauthor" id="e_dt_firstauthor"
							class="easyui-textbox" data-options="width:'200px'" readonly="readonly"/></td>

						<th>编辑2</th>
						<td><input name="secauthor" id="e_dt_secauthor"
							class="easyui-textbox" data-options="width:'200px'" readonly="readonly"/></td>
					</tr>

					<tr>
						<th>编辑3</th>
						<td><input name="threeauthor" id="e_dt_threeauthor"
							class="easyui-textbox" data-options="width:'200px'" readonly="readonly"/></td>

						<th>编辑4</th>
						<td><input name="fourauthor" id="e_dt_fourauthor"
							class="easyui-textbox" data-options="width:'200px'"
							onclick="seachObjauthor()" readonly="readonly"/></td>

					</tr>
					<tr>
						<th>编辑5</th>
						<td><input name="fiveauthor" id="e_dt_fiveauthor"
							class="easyui-textbox" data-options="width:'200px'"
							onclick="seachObjauthor()" readonly="readonly"/></td>

						<th>其他编辑</th>
						<td><input name="otherauthor" id="e_dt_otherauthor"
							class="easyui-textbox" data-options="width:'200px'" readonly="readonly"/></td>
					</tr>
				</table>
			</fieldset>
			<fieldset>
				<legend>附件</legend>
				<table class="altrowstable" cellspacing=”0″ cellpadding=”2″>
					<tr>
						<th>附件</th>
						<td colspan="3"><input type="file" name="upload"
							id="e_dt_upload"></td>
					</tr>

					<input type="hidden" name="dtid" id="e_dt_dtid" />
					<input type="hidden" name="firsteditorcode"
						id="e_dt_firsteditorcode" />
					<input type="hidden" name="seceditorcode" id="e_dt_seceditorcode" />
					<input type="hidden" name="thirdeditorcode"
						id="e_dt_thirdeditorcode" />
					<input type="hidden" name="othereditorcode"
						id="e_dt_othereditorcode" />
					<input type="hidden" name="firstsubeditorcode"
						id="e_dt_firstsubeditorcode" />
					<input type="hidden" name="secsubeditorcode"
						id="e_dt_secsubeditorcode" />
					<input type="hidden" name="thirdsubeditorcode"
						id="e_dt_thirdsubeditorcode" />
					<input type="hidden" name="othersubeditorcode"
						id="e_dt_othersubeditorcode" />
					<input type="hidden" name="firstauthorcode"
						id="e_dt_firstauthorcode" />
					<input type="hidden" name="secauthorcode" id="e_dt_secauthorcode" />
					<input type="hidden" name="threeauthorcode"
						id="e_dt_threeauthorcode" />
					<input type="hidden" name="fourauthorcode" id="e_dt_fourauthorcode" />
					<input type="hidden" name="fiveauthorcode" id="e_dt_fiveauthorcode" />
					<input type="hidden" name="otherauthorcode"
						id="e_dt_otherauthorcode" />
					<input type="hidden" name="append" id="dt_edit_append" />
					<input type="hidden" name="examinestatus" id="e_dt_examinestatus" />
				</table>
		</form>
	</div>

	<div id="edit_dt_btn">
		<a href="javascript:void(0)" class="easyui-linkbutton"
			iconCls="icon-ok" onclick="editdt_btn_ok()">保存</a> <a
			href="javascript:void(0)" class="easyui-linkbutton"
			iconCls="icon-cancel" onclick="editdt_btn_cancel()">取消</a>
	</div>


	<div id="audit_dt_dialog" class="easyui-dialog"
		data-options="region:'north',border:false, cache:false, closed:true,modal:true,title: '审核地图',modal: true,buttons:'#audit_dt_btn'"
		style="width:380px;height:330px;padding-top:20px;padding-left:20px">
		<form id="audit_dt_form" method="post">
			<!--  <table cellpadding="5">    -->
			<table class="altrowstable" >	
				<tr>					
					<td><input type="radio" id="dt_audit_pass" name="audit"
						value="pass" checked>审核通过</td>
				</tr>
				<tr>				
					<td><input type="radio" id="dt_audit_reject" name="audit"
						value="reject">驳回</td>
				</tr>
				<tr>					
					<td><input id="dt_audit_opinion" name="audit_opinion"
						class="easyui-textbox" type="text" data-options="multiline:true"
						style="height:100px;width:300px"></td>
				</tr>
			</table>
		</form>
	</div>
	<div id="audit_dt_btn">
		<a href="javascript:void(0)" class="easyui-linkbutton"
			iconCls="icon-ok" onclick="auditdt_btn_ok()">保存</a> <a
			href="javascript:void(0)" class="easyui-linkbutton"
			iconCls="icon-cancel" onclick="auditdt_btn_cancel()">取消</a>
	</div>

	<div id="import_dt" class="easyui-dialog"
		data-options="region:'north',border:false, cache:false, closed:true,modal:true,title: '导入地图',modal: true,buttons:'#import_dt_btn'"
		style="width:400px;height: 250px;padding-top:20px;padding-left:20px">
		<form id="admin_map_importForm" method="post"
			enctype="multipart/form-data">
			<table>
				<tr>
					<th>附件</th>
					<td><input type="file" name="upload" id="dt_import"></td>
				</tr>
			</table>
		</form>
	</div>
	<div id="#import_dt_btn">
		<a href="javascript:void(0)" class="easyui-linkbutton"
			iconCls="icon-ok" onclick="editdt_btn_ok()">保存</a> <a
			href="javascript:void(0)" class="easyui-linkbutton"
			iconCls="icon-cancel" onclick="editdt_btn_cancel()">取消</a>
	</div>

	<!-- 论下载对话框  -->
	<div id="export_dt" class="easyui-dialog"
		data-options="region:'north',border:false, cache:false, closed:true,modal:true,title: '地图导出',modal: true,buttons:'#export_dt_btn'"
		style="width:620px;height: 500px;padding-top:20px;padding-left:20px">
		<form id="admin_map_exportForm" method="post"
			enctype="multipart/form-data">
			<table>
				<tr>
					<th>附件</th>
					<td><input type="file" name="upload" id="dt_import"></td>
				</tr>
			</table>
		</form>
	</div>
	<div id="#export_dt_btn">
		<a href="javascript:void(0)" class="easyui-linkbutton"
			iconCls="icon-ok" onclick="exportdt_btn_ok()">保存</a> <a
			href="javascript:void(0)" class="easyui-linkbutton"
			iconCls="icon-cancel" onclick="exportdt_btn_cancel()">取消</a>
	</div>

</body>
</html>

