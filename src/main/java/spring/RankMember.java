package spring;

public class RankMember {

	private long id;
	private int level;
	private int rank;

	public RankMember(int level, int rank) {
		this.level = level;
		this.rank = rank;
	}

	public void setId(long id) {
		this.id = id;
	}

	public long getId() {
		return id;
	}

	public int getLevel(){
		return level;
	}

	public int getRank() {
		return rank;
	}

}
