package spring;

public class AuthService {

	private MemberDao memberDao;
	
	public void setMemberDao(MemberDao memberDao) {
		this.memberDao = memberDao;
	}

	public AuthInfo authenticate(String email, String password) {
		Member member = memberDao.selectByEmail(email);
		if (member == null) {
			throw new IdPasswordNotMatchingException();
		}
		if (!member.matchPassword(password)) {
			throw new IdPasswordNotMatchingException();
		}
		return new AuthInfo(member.getId(), member.getEmail(), member.getName(), member.getPoint(), member.getLevel());
	}

	public AuthInfo pointLevelUpdate(long id){
		Member member = memberDao.selectById(id);
		if (member == null) {
			throw new IdPasswordNotMatchingException();
		}
		TetrisMember tetrisMember = memberDao.tetrisById(id);

		return new AuthInfo(member.getId(), member.getEmail(), member.getName(), tetrisMember.getPoint(), tetrisMember.getLevel());
	}

}
