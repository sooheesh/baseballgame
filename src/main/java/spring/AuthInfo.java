package spring;

public class AuthInfo {

	private Long id;
	private String email;
	private String name;
	private int point;
	private int level;
	private int rank;

	public AuthInfo(Long id, String email, String name, int point, int level) {
		this.id = id;
		this.email = email;
		this.name = name;
		this.point = point;
		this.level = level;
	}

	public Long getId() {
		return id;
	}

	public String getEmail() {
		return email;
	}

	public String getName() {
		return name;
	}

	public int getPoint() {
		return point;
	}

	public int getLevel() {
		return level;
	}

	public void setRank(int rank) {
		this.rank = rank;
	}

	public int getRank() {
		return rank;
	}
}
