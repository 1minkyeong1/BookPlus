package com.bookplus.API.DAO;

import java.util.List;

public interface APIDAO {
    List<String> getBooksByTag(String goods_title);
}
