package controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Created by student on 2017-06-20.
 */
@Controller
public class TestController {

    @RequestMapping("/test")
    public String handleTest() {
        return "test/progressBar";
    }
}
