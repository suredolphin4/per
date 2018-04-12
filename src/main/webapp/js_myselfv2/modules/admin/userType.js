/******************************************* Init Operator ******************************************/
var moduleLoaded = function() {
	$('#admin_usertype_datagrid').datagrid({
		url : $('#contextPath').val() + '/userTypeAction!datagrid.action',
		fit : true,
		fitColumns : true,
		border : false,
		pagination : true,
		idField : 'usertypeid',
		pageSize : 20,
		pageList : [ 10, 20, 30, 40, 50 ],
		sortName : 'name',
		sortOrder : 'asc',
		/*pagePosition : 'both',*/
		checkOnSelect : false,
		selectOnCheck : false,
		frozenColumns : [ [ {
			field : 'usertypeid',
			title : '编号',
			width : 150,
			checkbox : true
		}, {
			field : 'name',
			title : '用户类型名称',
			width : 150,
			sortable : true
		} ] ],
		columns : [ [{
			field : 'createdatetime',
			title : '创建时间',
			width : 150,
			sortable : true
		}, {
			field : 'modifydatetime',
			title : '最后修改时间',
			width : 150,
			sortable : true
		} ] ],
		toolbar : [ {
			text : '增加',
			iconCls : 'icon-add',
			handler : function() {
				append();
			}
		}, '-', {
			text : '删除',
			iconCls : 'icon-remove',
			handler : function() {
				remove();
			}
		}, '-', {
			text : '修改',
			iconCls : 'icon-edit',
			handler : function() {
				editfunc();
			}
		}, '-' , {
			text : '导入',
			iconCls : 'icon-impo',
			handler : function() {
				
				$('#admin_usertype_import').dialog('open');
			}
		}, '-' , {
			text : '导出',
			iconCls : 'icon-export',
			handler : function() {
				exportfunc();
//				$('#admin_usertype_comBar').dialog('open');
			}
		}]
	
		
		
	});
	
	$('#dd2').datebox({
		onSelect: function(date){
			alert(date.getFullYear()+":"+(date.getMonth()+1)+":"+date.getDate());
		}
	});
};

/******************************************* User Category Manage Operator ******************************************/
var exportfunc = function() {
	// $('#export_lw').dialog("open");
	downloadExcel('userTypeAction!downloadExcel.action');
};


function searchFun() {
	$('#admin_usertype_datagrid').datagrid('load', serializeObject($('#admin_usertype_searchForm')));
}
function clearFun() {
	$('#admin_usertype_layout input[name=name]').val('');
	$('#admin_usertype_datagrid').datagrid('load', {});
}
function append() {
  
	$('#admin_usertype_addForm input').val('');
	$('#admin_usertype_addDialog').dialog('open');
	
	
}

function remove() {
	var rows = $('#admin_usertype_datagrid').datagrid('getChecked');
	console.info(rows);
	var ids = [];
	if (rows.length > 0) {
		$.messager.confirm('确认', '您是否要删除当前选中的项目？', function(r) {
			if (r) {
				for ( var i = 0; i < rows.length; i++) {
					ids.push(rows[i].usertypeid);
			
				}
				$.ajax({
					url : $('#contextPath').val() + '/userTypeAction!remove.action',
					data : {
						ids : ids.join(',')
					},
					dataType : 'json',
					success : function(r) {
						$('#admin_usertype_datagrid').datagrid('load');
						$('#admin_usertype_datagrid').datagrid('unselectAll');
						$.messager.show({
							title : '提示',
							msg : r.msg
						});
					}
				});
			}
		});
	} else {
		$.messager.show({
			title : '提示',
			msg : '请勾选要删除的记录！'
		});
	}
}



	
	//属性编辑操作
	function editfunc() {
		var rows = $('#admin_usertype_datagrid').datagrid('getChecked');
		// 只能编辑一行
		if (rows.length == 1) {
			// 回显
			$('#admin_usertype_editDialog').dialog('open');
			
			//$('#e_usertype_usertypeid').textbox('setValue',rows[0].usertypeid);
			$('#e_usertype_usertypeid').val(rows[0].usertypeid);
			$('#e_usertype_name').textbox('setValue', rows[0].name);
			
		
		}else{
			$.messager.alert("提示", "只能编辑选中的一行记录！请您重新选择");
		}
	};

	var editdt_btn_ok = function() {
		$('#admin_usertype_editForm').form('submit', {
			url : $('#contextPath').val() + '/userTypeAction!edit.action',
			onSubmit : function(param) {
				return $(this).form('validate');
			},
			success : function(r) {
				// 修改成功，解析返回的json信息
				var objr = jQuery.parseJSON(r);
				if (objr.success) {
					$('#admin_usertype_datagrid').datagrid('reload');
					$('#admin_usertype_editDialog').dialog('close');
				}

				$.messager.show({
					title : '提示',
					msg : objr.msg
				});

				$('#admin_usertype_editDialog').dialog('close');
			}
		});
	};

	var editdt_btn_cancel = function() {
		$('#admin_usertype_editDialog').dialog('close');
	};
