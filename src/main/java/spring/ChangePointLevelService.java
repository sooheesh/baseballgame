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
    public void changePointLevel(long id, int newPoint, int newLevel) {
        TetrisMember tetrisMember = memberDao.tetrisById(id);
        if (tetrisMember == null)
            throw new MemberNotFoundException();

        tetrisMember.changePointLevel(newPoint, newLevel);

        memberDao.updatePointLevel(tetrisMember);
    }
}
