package controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * Created by sooheesong on 30/06/2017.
 */
@Controller
@RequestMapping("/tetrisFight")
public class TetrisFightController {

    @RequestMapping(method = RequestMethod.GET)
    public String tetrisFightView() {
        return "game/tetrisFight";
    }
}
