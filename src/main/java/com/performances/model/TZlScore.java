package com.performances.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.annotations.GenericGenerator;

@Entity
@Table(name="t_zl_score",catalog="per")
@DynamicUpdate(true) // 允许部分更新
public class TZlScore {
	private Integer id;
	private Integer fid;
	private String  year;
    private double	score;
    private String 	usercode;
    private int		position;
    
    @GenericGenerator(name="generator", strategy="increment")
    @Id 
    @GeneratedValue(generator="generator")
    @Column(name="id", unique=true, nullable=false)
    public Integer getId() {
        return this.id;
    }
    public void setId(int id) {
		this.id = id;
	}
    
    @Column(name = "fid")
	public int getFid() {
		return fid;
	}
	public void setFid(int fid) {
		this.fid = fid;
	}
	
	@Column(name = "year",length=50)
	public String getYear() {
		return year;
	}
	public void setYear(String year) {
		this.year = year;
	}
	
    @Column(name = "score")
	public double getScore() {
		return score;
	}
	public void setScore(double score) {
		this.score = score;
	}

	@Column(name = "usercode", length=150)
	public String getUsercode() {
		return usercode;
	}
	public void setUsercode(String usercode) {
		this.usercode = usercode;
	}

	@Column(name = "position")
	public int getPosition() {
		return position;
	}
	public void setPosition(int position) {
		this.position = position;
	}
}
