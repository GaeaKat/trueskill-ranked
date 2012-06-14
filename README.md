trueskill-ranked
================

Ranked Ruby Trueskill


This is based off the python TrueSkill made by [Heungsub Lee](http://subl.ee/).

Measure Player’s Skill
======================
    r1, r2, r3 = Rating.new, Rating.new, Rating.new
    team1 = [r1, r2]
    team2 = [r3]

	g().transform_ratings([team1+team2],[0,1])
	#.[[[mu=25.604234703783792,sigma=8.074905921631995],[mu=25.604234703783792,sigma=8.074905921631995]],[[mu=24.395765296216204,sigma=8.074905921631995]]]
