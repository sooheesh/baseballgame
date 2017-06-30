package spring;

import java.util.Date;

public class Member {

	private Long id;
	private String email;
	private String password;
	private String name;
	private Date registerDate;
	private int point;
	private int level;

	public Member(String email, String password, String name, Date registerDate, int point, int level) {
		this.email = email;
		this.password = password;
		this.name = name;
		this.registerDate = registerDate;
		this.point = point;
		this.level = level;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getId() {
		return id;
	}

	public String getEmail() {
		return email;
	}

	public String getPassword() {
		return password;
	}

	public String getName() {
		return name;
	}

	public Date getRegisterDate() {
		return registerDate;
	}

	public int getPoint(){
		return point;
	}

	public int getLevel(){
		return level;
	}


	public void changePassword(String oldPassword, String newPassword) {
		if (!password.equals(oldPassword))
			throw new IdPasswordNotMatchingException();
		this.password = newPassword;
	}

	public boolean matchPassword(String pwd) {
		return this.password.equals(pwd);
	}
}
