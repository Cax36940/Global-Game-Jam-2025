class_name Cost

var na: int
var cl: int
var h: int
var o: int

func _init(na, cl, h, o) -> void:
	self.na = na
	self.cl = cl
	self.h = h
	self.o = o

static func multiply(cost: Cost, f: int) -> Cost:
	return Cost.new(cost.na*f, cost.cl*f, cost.h*f, cost.o*f)

func multiply_self(f: int) -> void:
	self.na *= f
	self.cl *= f
	self.h *= f
	self.o *= f


static var costs = {
	"H2": Cost.new(0, 0, 2, 0),
	"O2": Cost.new(0, 0, 0, 2),
	"NaCl": Cost.new(1, 1, 0, 0),
	"NaClO": Cost.new(1, 1, 0, 1),
	"NaClO3": Cost.new(1, 1, 0, 3),
	"NaClO4": Cost.new(1, 1, 0, 4),
	"NaOH": Cost.new(1, 0, 1, 1),
	"HCl": Cost.new(0, 1, 1, 0)
}


static func parse_from_costs(cost: Cost) -> String:
	for key in costs:
		if (costs[key].na == 0 and cost.na != 0) \
			or (costs[key].cl == 0 and cost.cl != 0) \
			or (costs[key].h == 0 and cost.h != 0) \
			or (costs[key].o == 0 and cost.o != 0):
			continue
		
		var q = -1
		if costs[key].na != 0:
			var r = cost.na % costs[key].na
			if r != 0: continue
			q = cost.na / costs[key].na
		
		if costs[key].cl != 0:
			var r = cost.cl % costs[key].cl
			if r != 0: continue
			var n = cost.cl / costs[key].cl
			if q == -1:
				q = n
			elif q != n: continue
		
		if costs[key].h != 0:
			var r = cost.h % costs[key].h
			if r != 0: continue
			var n = cost.h / costs[key].h
			if q == -1:
				q = n
			elif q != n: continue
		
		if costs[key].o != 0:
			var r = cost.o % costs[key].o
			if r != 0: continue
			var n = cost.o / costs[key].o
			if q == -1:
				q = n
			elif q != n: continue
		
		return str(q) + " " + key
	return (str(cost.na) + " Na+, " if cost.na != 0 else "") \
		+ (str(cost.cl) + " Cl-, " if cost.cl != 0 else "") \
		+ (str(cost.h) + " H+, " if cost.h != 0 else "") \
		+ (str(cost.o) + " O-" if cost.o != 0 else "")
