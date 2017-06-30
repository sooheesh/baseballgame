package controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import spring.AuthInfo;
import spring.AuthService;
import spring.ChangePointLevelService;
import javax.servlet.http.HttpSession;


/**
 * Created by student on 2017-06-20.
 */
@Controller
@RequestMapping("/baseball")
public class ChangePntLvlController {
//
//    private ChangePointLevelService changePointLevelService;
//    private AuthService authService;
//
//    public void setAuthService(AuthService authService) {
//        this.authService = authService;
//    }
//
//    public void setChangePointLevelService(
//            ChangePointLevelService changePointLevelService) {
//        this.changePointLevelService = changePointLevelService;
//    }
//
//    @RequestMapping(method = RequestMethod.GET)
//    public String baseballView() {
//        return "game/baseball";
//    }
//
//    @RequestMapping(method = RequestMethod.POST)
//    public String ajaxView(
//            @RequestBody ChangePntLvlCommand pntLvlCmd,
//            HttpSession session) {
//
//        AuthInfo authInfo = (AuthInfo) session.getAttribute("authInfo");
//
//        changePointLevelService.changePointLevel(
//                authInfo.getEmail(),
//                pntLvlCmd.getNewPoint(),
//                pntLvlCmd.getNewLevel()
//        );
//
//        AuthInfo authInfo2 = authService.pointLevelUpdate(authInfo.getEmail());
//
//        session.setAttribute("authInfo", authInfo2);
//
//        return "game/baseball";
//    }
//}

    private ChangePointLevelService changePointLevelService;
    private AuthService authService;

    public void setAuthService(AuthService authService) {
        this.authService = authService;
    }

    public void setChangePointLevelService(
            ChangePointLevelService changePointLevelService) {
        this.changePointLevelService = changePointLevelService;
    }

    @RequestMapping(value = "/tetris", method = RequestMethod.GET)
    public String tetrisView() {
        return "game/tetris";
    }

    @RequestMapping(value = "/baseball", method = RequestMethod.GET)
    public String baseballView() {
        return "game/baseball";
    }

    @RequestMapping(value = "/tetris", method = RequestMethod.POST)
    public String ajaxTetris(
            @RequestBody ChangePntLvlCommand pntLvlCmd,
            HttpSession session) {

        AuthInfo authInfo = (AuthInfo) session.getAttribute("authInfo");

        changePointLevelService.changePointLevel(
                authInfo.getId(),
                pntLvlCmd.getNewPoint(),
                pntLvlCmd.getNewLevel()
        );

        AuthInfo authInfo2 = authService.pointLevelUpdate(authInfo.getId());

        session.setAttribute("authInfo", authInfo2);

        return "game/tetris";
    }

    @RequestMapping(value = "/baseball", method = RequestMethod.POST)
    public String ajaxBaseball(
            @RequestBody ChangePntLvlCommand pntLvlCmd,
            HttpSession session) {

        AuthInfo authInfo = (AuthInfo) session.getAttribute("authInfo");

        changePointLevelService.changePointLevel(
                authInfo.getId(),
                pntLvlCmd.getNewPoint(),
                pntLvlCmd.getNewLevel()
        );

        AuthInfo authInfo2 = authService.pointLevelUpdate(authInfo.getId());

        session.setAttribute("authInfo", authInfo2);

        return "game/baseball";
    }
}