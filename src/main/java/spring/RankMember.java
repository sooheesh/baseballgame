package spring;

public class RankMember {

	private String name;
	private int level;
	private int rank;

	public RankMember(int level, int rank) {
		this.level = level;
		this.rank = rank;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getName() {
		return name;
	}

	public int getLevel(){
		return level;
	}

	public int getRank() {
		return rank;
	}

}
