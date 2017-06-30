package spring;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Date;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.PreparedStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;

public class MemberDao {

	private JdbcTemplate jdbcTemplate;
	private RowMapper<Member> memRowMapper = new RowMapper<Member>() {
		@Override
		public Member mapRow(ResultSet rs, int rowNum)
				throws SQLException {
			Member member = new Member(
					rs.getString("EMAIL"),
					rs.getString("PASSWORD"),
					rs.getString("NAME"),
					rs.getTimestamp("REGDATE"),
					rs.getInt("POINT"),
					rs.getInt("LEVEL")
			);
			member.setId(rs.getLong("ID"));
			return member;
		}
	};

	public MemberDao(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource);
	}

	public Member selectByEmail(String email) {
		List<Member> results = jdbcTemplate.query(
				"select * from MEMBER where EMAIL = ?",
				memRowMapper,
				email);

		return results.isEmpty() ? null : results.get(0);
	}

	public void insert(final Member member) {
		KeyHolder keyHolder = new GeneratedKeyHolder();
		jdbcTemplate.update(new PreparedStatementCreator() {
			@Override
			public PreparedStatement createPreparedStatement(Connection con) 
					throws SQLException {
				PreparedStatement pstmt = con.prepareStatement(
						"insert into MEMBER (EMAIL, PASSWORD, NAME, REGDATE, POINT, LEVEL) "+
						"values (?, ?, ?, ?, ?, ?)",
						new String[] {"ID"});
				pstmt.setString(1,  member.getEmail());
				pstmt.setString(2,  member.getPassword());
				pstmt.setString(3,  member.getName());
				pstmt.setTimestamp(4,  
						new Timestamp(member.getRegisterDate().getTime()));
				pstmt.setInt(5, member.getPoint());
				pstmt.setInt(6,member.getLevel());
				return pstmt;
			}
		}, keyHolder);
		Number keyValue = keyHolder.getKey();
		member.setId(keyValue.longValue());
	}

	public void update(Member member) {
		jdbcTemplate.update("update MEMBER set NAME = ?, PASSWORD = ? where EMAIL = ?",
				member.getName(), member.getPassword(), member.getEmail());
	}

	public void updatePointLevel(TetrisMember tetrisMember) {
		jdbcTemplate.update("update TETRIS set POINT = ?, LEVEL = ? where ID = ?",
				tetrisMember.getPoint(), tetrisMember.getLevel(), tetrisMember.getId());
	}

	public List<Member> selectAll() {
		List<Member> results = jdbcTemplate.query("select * from MEMBER",
				memRowMapper);
		return results;
	}

	public int count() {
		Integer count = jdbcTemplate.queryForObject("select count(*) from MEMBER", Integer.class);
		return count;
	}

	public List<Member> selectByRegdate(Date from, Date to) {
		List<Member> results = jdbcTemplate.query(
				"select * from MEMBER where REGDATE between ? and ? "+
				"order by REGDATE desc",
				memRowMapper,
				from, to);
		return results;
	}
	
	public Member selectById(Long id) {
		List<Member> results = jdbcTemplate.query(
				"select * from MEMBER where ID = ?",
				memRowMapper,
				id);

		return results.isEmpty() ? null : results.get(0);
	}


	private RowMapper<RankMember> rankMemRowMapper = new RowMapper<RankMember>() {
		@Override
		public RankMember mapRow(ResultSet rs, int rowNum)
				throws SQLException {
			RankMember rankMember = new RankMember(
					rs.getInt("LEVEL"),
					rs.getInt("RANK")
			);
			rankMember.setId(rs.getLong("ID"));
			return rankMember;
		}
	};


	public List<RankMember> rankById() {
		List<RankMember> results = jdbcTemplate.query(
				"select ID, rank() over (order by LEVEL desc, POINT desc) as RANK, LEVEL from TETRIS " +
						"order by LEVEL desc, POINT desc",
				rankMemRowMapper);
		return results;
	}

	private RowMapper<TetrisMember> tetrisMemRowMapper = new RowMapper<TetrisMember>() {
		@Override
		public TetrisMember mapRow(ResultSet rs, int rowNum)
				throws SQLException {
			TetrisMember TetrisMember = new TetrisMember(
					rs.getInt("POINT"),
					rs.getInt("LEVEL")
			);
			TetrisMember.setId(rs.getInt("ID"));
			return TetrisMember;
		}
	};

	public TetrisMember tetrisById(Long id) {
		List<TetrisMember> results = jdbcTemplate.query(
				"select * from TETRIS where ID = ?",
				tetrisMemRowMapper,
				id);

		return results.isEmpty() ? null : results.get(0);
	}


}
