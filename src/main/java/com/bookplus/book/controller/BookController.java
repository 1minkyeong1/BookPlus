package com.bookplus.book.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/book")
public class BookController {

    @RequestMapping("/kakaobook.do")
    public String showKakaoBookPage() {
        return "/book/kakaobook"; 
    }
}
