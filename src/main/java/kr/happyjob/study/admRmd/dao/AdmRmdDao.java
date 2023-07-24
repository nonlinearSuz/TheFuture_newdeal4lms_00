package kr.happyjob.study.admRmd.dao;

import java.util.List;
import java.util.Map;


import kr.happyjob.study.system.model.ComnCodUtilModel;
import kr.happyjob.study.system.model.ComnDtlCodModel;
import kr.happyjob.study.system.model.ComnGrpCodModel;

import kr.happyjob.study.admRmd.model.RoomModel;

public interface AdmRmdDao {

   //** 강의실 목록 조회 *//*
   public List<RoomModel> roomlist(Map<String, Object> paramMap)throws Exception;
   
   //** 강의실 목록 카운트 조회 *//*
   public int roomcountlist(Map<String, Object> paramMap)throws Exception;
  
    /** 한건 조회 */
	public RoomModel selectoneroom(Map<String, Object> paramMap) throws Exception;
	
	
	/** 최대 key값 */
	public int max_num(Map<String, Object> paramMap) throws Exception;
	
	
	/** 등록 */
	public int insertroom(Map<String, Object> paramMap) throws Exception;

	/** 수정 */
	public int updateroom(Map<String, Object> paramMap) throws Exception;

	/** 삭제 */
	public int deleteroom(Map<String, Object> paramMap) throws Exception;
	
	//** 물품 목록 조회 *//*
	public List<RoomModel> itemlist(Map<String, Object> paramMap)throws Exception;
	   
	//** 물품 목록 카운트 조회 *//*
	public int itemcountlist(Map<String, Object> paramMap)throws Exception;
	
	
	
	
	
	/** optional lecview */
		public RoomModel usability(Map<String, Object> paramMap) throws Exception;

	
};
   
