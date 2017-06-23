package controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import spring.AuthInfo;
import spring.RankMember;
import spring.MemberDao;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
public class RankController {

    private MemberDao memberDao;

    public void setMemberDao(MemberDao memberDao) {
        this.memberDao = memberDao;
    }

    @RequestMapping("/rank")
    public String rankList(Model model) {

        List<RankMember> rankMembers = memberDao.rankById();

        model.addAttribute("rankMembers", rankMembers);

        return "game/rank";
    }
}