package kr.happyjob.study.admtbl.dao;

import java.util.List;
import java.util.Map;

import kr.happyjob.study.admtbl.model.RoomModel;
import kr.happyjob.study.admtbl.model.TimetableModel;

public interface AdmtblDao {
//주석주석삭제	
	List<TimetableModel> timeList(Map<String, Object> paramMap)throws Exception;
	List<RoomModel> roomList(Map<String, Object> paramMap)throws Exception;

}
