package spring;

public class TetrisMember {


    private long id;
    private int point;
    private int level;

    public TetrisMember(int point, int level) {
        this.point = point;
        this.level = level;
    }

    public void setId(long id) {
        this.id = id;
    }

    public Long getId() {
        return id;
    }

    public int getPoint() {
        return point;
    }

    public int getLevel(){
        return level;
    }

    public void changePointLevel(int newPoint, int newLevel){
        this.point = newPoint;
        this.level = newLevel;
    }
}
