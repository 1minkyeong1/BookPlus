package com.bookplus.admin.goods.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

public interface AdminGoodsController {
    public ModelAndView adminGoodsMain(@RequestParam Map<String, String> dateMap,
                                       HttpServletRequest request, HttpServletResponse response) throws Exception;

    public ResponseEntity addNewGoods(MultipartHttpServletRequest multipartRequest,
                                      HttpServletRequest request, HttpServletResponse response) throws Exception;

    public ResponseEntity modifyGoodsInfo(@RequestParam("goods_isbn") String goods_isbn,
                                          @RequestParam("attribute") String attribute,
                                          @RequestParam("value") String value,
                                          HttpServletRequest request, HttpServletResponse response) throws Exception;

    public void removeGoodsImage(@RequestParam("goods_isbn") String goods_isbn,
                                 @RequestParam("imageFileName") String imageFileName,
                                 HttpServletRequest request, HttpServletResponse response) throws Exception;

    public void addNewGoodsImage(MultipartHttpServletRequest multipartRequest,
                                 HttpServletRequest request, HttpServletResponse response) throws Exception;

    public void modifyGoodsImageInfo(MultipartHttpServletRequest multipartRequest,
                                     HttpServletRequest request, HttpServletResponse response) throws Exception;
}
