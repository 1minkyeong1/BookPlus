package com.bookplus.common.file;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import net.coobird.thumbnailator.Thumbnails;


@Controller
public class FileDownloadController {
	
	
	//이미지 파일 이름과 상품 id를 가져옵니다.
	@RequestMapping("/download")
	protected void download(@RequestParam("fileName") String fileName,
	                        @RequestParam("goods_id") String goods_id,
	                        HttpServletRequest request, HttpServletResponse response) throws Exception {

	    OutputStream out = response.getOutputStream();
	    String path = request.getSession().getServletContext().getRealPath("/resources/image/shopping/file_repo");

	    String filePath = path + "/" + goods_id + "/" + fileName;
	    File image = new File(filePath);

	    response.setHeader("Cache-Control", "no-cache");

	    // 파일 이름을 URL 인코딩하여 헤더에 추가
	    String encodedFileName = java.net.URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", "%20");
	    response.addHeader("Content-Disposition", "attachment; filename=\"" + encodedFileName + "\"");

	    try (FileInputStream in = new FileInputStream(image)) {
	        byte[] buffer = new byte[1024 * 8];
	        int count;
	        while ((count = in.read(buffer)) != -1) {
	            out.write(buffer, 0, count);
	        }
	    }
	    out.close();
	}

	
	
	@RequestMapping("/thumbnails.do")
	protected void thumbnails(@RequestParam("fileName") String fileName,
                            	@RequestParam("goods_id") String goods_id,
    		                 	HttpServletRequest request, HttpServletResponse response) throws Exception {

        String path = request.getSession().getServletContext().getRealPath("/resources/image/shopping/file_repo");
		OutputStream out = response.getOutputStream();
		String filePath=path+"/"+goods_id+"/"+fileName;
		File image=new File(filePath);
		
		//메인 페이지 이미지를 썸네일 이미지로 표시 하는 부분
		if (image.exists()) { 
			Thumbnails.of(image).size(121,154).outputFormat("png").toOutputStream(out);
		}
		byte[] buffer = new byte[1024 * 8];
		out.write(buffer);
		out.close();
	}
}

