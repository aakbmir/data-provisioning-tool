package common;

public class QueryConstants {

	public static final String REGISTER_QUERY = "insert into user_spec(first_name,last_name,user_id,is_admin) values (?,?,?,?)";
	
	public static final String AGR_CODE = "select credit_account_number from CIM_SIT.cim_credit_account where account_sid in ( select account_sid from CIM_SIT.cim_retail_account where retail_account_number= ?)";

	public static final String PREVIOUS_VALUES = "SELECT * FROM validation_points_data WHERE account_number= ? order by date_created desc";
	
	public static final String VALIDATION_POINT_INSERT = "Insert into validation_points_data (ACCOUNT_NUMBER,DATE_CREATED,CIM_NEXT_STATEMENT_DATE,FIN_NEXT_STATEMENT_DATE,FIN_OPEN_TO_BUY,CAM_BNPL_ELIGIBILITY_IND,CIM_BNPL_ELIGIBILITY_IND,CIM_USER_PROFILE_NUMBER,CIM_PAYMENT_DUE_DAY,FIN_PAYMENT_DUE_DATE,CIM_POST_CODE,CAM_BRAND,CIM_ARREARS_INDICATOR,FIN_ARREARS_INDICATOR,CAM_ORDER_COUNT,FIN_OVERALL_BALANCE,FIN_OFFERS,FIN_APR) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
}