package com.bookplus.API.DAO;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class APIDAOImpl implements APIDAO {

    @Autowired
    private SqlSession sqlSession;

    private static final String NAMESPACE = "com.bookplus.API.mappers.APIWeatherMapper";

    @Override
    public List<String> getBooksByTag(String goods_title) {
        return sqlSession.selectList(NAMESPACE + ".selectBooksByTag", goods_title);
    }
}
