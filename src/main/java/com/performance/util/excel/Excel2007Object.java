package com.performance.util.excel;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.lang.reflect.Field;
import java.lang.reflect.Method;

import org.apache.commons.io.FileUtils;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.performance.pagemodel.Domain;
import com.performance.pagemodel.Lw;
import com.performances.model.TDomain;

public class Excel2007Object<T> implements ExcelObject<T> {

	private XSSFWorkbook xwb;
	private Map<Integer, String> columns;
	
	protected Excel2007Object(){};
	
	public Excel2007Object(InputStream fis) throws IOException{
		xwb = new XSSFWorkbook(fis);
		columns = new HashMap<Integer, String>();
	}
	
	public Excel2007Object(File file) throws IOException, InvalidFormatException{
		xwb = new XSSFWorkbook(file);
		columns = new HashMap<Integer, String>();
	}
	
	@Override
	public List<String> GetSheetNames() {
		List<String> sheets = new ArrayList<String>();
		for(int i = 0; i < xwb.getNumberOfSheets(); i++)
		{
			XSSFSheet sheet = xwb.getSheetAt(i);
			if(sheet == null || sheet.getPhysicalNumberOfRows() < 1)
				continue;
			sheets.add(xwb.getSheetName(i));
		}
		
		return sheets;
	}

	@Override
	public Map<Integer, String> GetSheetColumns(int sheetIndex) {
		XSSFCell cell = null;
		Map<Integer, String> columns = new HashMap<Integer, String>();
		XSSFSheet sheet = xwb.getSheetAt(sheetIndex);
		XSSFRow row = sheet.getRow(sheet.getFirstRowNum());
		for (int j = row.getFirstCellNum(); j <= row.getLastCellNum(); j++) {
			cell = row.getCell(j);
			if (cell == null) {
				continue;
			}
			columns.put(j, cell.getStringCellValue());
		}
		
		return columns;
	}

	public Map<Integer, Integer> GetSheetColumnTypes(int sheetIndex)
	{
		XSSFRow row = null;
		XSSFCell cell = null;
		Map<Integer, Integer> columnTypes = new HashMap<Integer, Integer>();
		XSSFSheet sheet = xwb.getSheetAt(sheetIndex);
		for (int i = sheet.getFirstRowNum() + 1; i < sheet
				.getPhysicalNumberOfRows(); i++) {
			row = sheet.getRow(i);
			if (row == null) {
				continue;
			}
			
			for (int j = row.getFirstCellNum(); j <= row.getLastCellNum(); j++) {
				cell = row.getCell(j);
				if (cell == null) {
					continue;
				}
				columnTypes.put(j, cell.getCellType());
			}
			
			if(columnTypes.size() > 0)
				break;
		}

		return columnTypes;
	}
	
	@Override
	public String GetMatchInfo(int sheetIndex, T t, List<String> columns) {
		Map<Integer, String> mapColumns = GetSheetColumns(sheetIndex);
		Map<Integer, Integer> columnTypes = GetSheetColumnTypes(sheetIndex);
		Field [] fields = t.getClass().getDeclaredFields();
		for(int i=0; i< fields.length; i++)
        {
			if(columns.size() > i)
			{
				Integer columnType = FindColumnType(mapColumns, columnTypes, columns.get(i));
				if(columnType == Integer.MIN_VALUE){
					return "无法获取列" + columns.get(i) + "的类型";
				}
				
	            Field f = fields[i];
	            String type = f.getGenericType().toString();
	            switch(type)
	            {
	            	case "class java.lang.String":
	            		break;
	            	case "class java.lang.Integer":
	            	case "class java.lang.Double":
	            	case "class java.lang.Short":
	            	{
	            		if(columnType != XSSFCell.CELL_TYPE_NUMERIC || 
	            				columnType != XSSFCell.CELL_TYPE_BLANK){
	            			return "Excel表列" + columns.get(i) + " 与数据表对象属性 " + f.getName() + " 无法匹配";
	            		}
	            		break;
	            	}
	            	
	            	case "class java.lang.Boolean":
	            	case "boolean":
	            	{
	            		if(columnType != XSSFCell.CELL_TYPE_BOOLEAN || 
	            				columnType != XSSFCell.CELL_TYPE_BLANK){
	            			return "Excel表列" + columns.get(i) + " 与数据表对象属性 " + f.getName() + " 无法匹配";
	            		}
	            		break;
	            	}
	            	case "class java.util.Date":
	            		break;
	            	default:
	            		break;
	            }
			}
        }
		
		return "";
	}
		

	@Override
	public int GetCellType(int sheetIndex, int nrow, int ncell) {
		XSSFSheet sheet = xwb.getSheetAt(sheetIndex);
		if(sheet == null)
			return Integer.MIN_VALUE;
		XSSFRow row = sheet.getRow(nrow);
		if(row == null)
			return Integer.MIN_VALUE;
		XSSFCell cell = row.getCell(ncell);
		if(cell == null)
			return Integer.MIN_VALUE;
		
		return cell.getCellType();
	}

	@Override
	public Object GetCellValue(int sheetIndex, int nrow, int ncell) {
		XSSFSheet sheet = xwb.getSheetAt(sheetIndex);
		if(sheet == null)
			return null;
		XSSFRow row = sheet.getRow(nrow);
		if(row == null)
			return null;
		XSSFCell cell = row.getCell(ncell);
		if(cell == null)
			return null;
		
		DecimalFormat df = new DecimalFormat("0");// 格式化 number String
		// 字符
		SimpleDateFormat sdf = new SimpleDateFormat(
		"yyyy-MM-dd HH:mm:ss");// 格式化日期字符串
		DecimalFormat nf = new DecimalFormat("0.00");// 格式化数字

		
		switch (cell.getCellType())
		{
		case XSSFCell.CELL_TYPE_STRING:
			return cell.getStringCellValue();

		case XSSFCell.CELL_TYPE_NUMERIC:
			if ("@".equals(cell.getCellStyle().getDataFormatString())) {
				return cell.getNumericCellValue();	//df.format(cell.getNumericCellValue());
			} else if ("General".equals(cell.getCellStyle()
					.getDataFormatString())) {
				return cell.getNumericCellValue();
				//return nf.format(cell.getNumericCellValue());
			} else {
				return sdf.format(HSSFDateUtil.getJavaDate(cell
						.getNumericCellValue()));
			}
		case XSSFCell.CELL_TYPE_BOOLEAN:
			return  cell.getBooleanCellValue();
		case XSSFCell.CELL_TYPE_BLANK:
			return "";
		default:
			return cell.toString();
		}
	}

	public T SetModelValue(T t, int sheetIndex, int nrow, Map<Integer, Integer> mapRelations, List<Match> matches){
		XSSFSheet sheet = xwb.getSheetAt(sheetIndex);
		if(sheet == null)
			return null;
		XSSFRow row = sheet.getRow(nrow);
		if(row == null)
			return null;
		
		Field [] fields = t.getClass().getDeclaredFields();
		for (Entry<Integer, Integer> entry : mapRelations.entrySet()) {
			Field f = fields[entry.getKey()];
			JavaClass.setFieldValue(t, f, GetCellValue(sheetIndex, nrow, entry.getValue()), matches);
		}
		
		return t;
	}
	
	public Map<Integer, Integer> GetMapRelationIndexs(T t, int sheetIndex, Map<String, String> relations){
		Map<Integer, Integer> maps = new HashMap<Integer, Integer>();
		
		Map<Integer, String> columns = GetSheetColumns(sheetIndex);
		Field [] fields = t.getClass().getDeclaredFields();
		
		for (Entry<String, String> entry : relations.entrySet()) {
			int keyIndex=0;
			if(columns.containsValue(entry.getValue())){
				//1.获取对象属性顺序号
				for(Field field : fields){
					if(field.getName().equals(entry.getKey())){
						break;
					}
					keyIndex++;
				}
				if(keyIndex == fields.length){
					continue;
				}
				
				//2.获取Sheet列顺序号
				for (Entry<Integer, String> columnEntry : columns.entrySet()) {
					if(columnEntry.getValue().equals(entry.getValue())){
						maps.put(keyIndex, columnEntry.getKey());
						break;
					}
				}
			}
		}
		
		return maps;
	}
	
	public int getNumberOfRows(int indexName)
	{
		XSSFSheet sheet = xwb.getSheetAt(indexName);
		return sheet.getPhysicalNumberOfRows();
	}
	
	public int getStartPosOfRow(int indexName)
	{
		XSSFSheet sheet = xwb.getSheetAt(indexName);
		return sheet.getFirstRowNum();
	}
	
	private Integer FindColumnType(Map<Integer, String> mapColumns, Map<Integer, Integer> columnTypes, String columnName)
	{
		if(!mapColumns.containsValue(columnName))
		{
			return Integer.MIN_VALUE;
		}
		
		for (Entry<Integer, String> entry : mapColumns.entrySet()) {
	        if (columnName.equals(entry.getValue())) {
	        	if(columnTypes.containsKey(entry.getKey()))
	        	{
	        		return columnTypes.get(entry.getKey());
	        	} else {
	        		return Integer.MIN_VALUE;
	        	}
	        }
		}
		
		return Integer.MIN_VALUE;
	}
}
