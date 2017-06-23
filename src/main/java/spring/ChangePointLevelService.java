package spring;

import org.springframework.transaction.annotation.Transactional;

/**
 * Created by student on 2017-06-20.
 */
public class ChangePointLevelService {

    private MemberDao memberDao;

    public ChangePointLevelService(MemberDao memberDao) {
        this.memberDao = memberDao;
    }

    @Transactional
    public void changePointLevel(String email, int newPoint, int newLevel) {
        Member member = memberDao.selectByEmail(email);
        if (member == null)
            throw new MemberNotFoundException();

        member.changePointLevel(newPoint, newLevel);

        memberDao.updatePointLevel(member);
    }
}
