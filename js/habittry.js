const JSdaysLayout = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]; // How days of the week work in JS.

class Habit{
    constructor(id, title, description, frequency, reminderTime, status, finite, startDate, streakLayout){
        this.id = id; // Id number is passed over from the user side, based on how many habits the user has already created.
        this.now = Date.now();
        this.created = new Date(this.now);
        this.status = status; // Whether it is an active habit. Can get changed to "archived", "recycled", "scheduled" or "upcoming". etc.

        // Things that the user is allowed to decide:
        this.title = title;
        this.description = description;
        this.frequency = frequency;
        this.reminderTime = reminderTime;
        this.finite = finite; // Optional, user can decide if it's a short-term habit (i.e. 10 days of trying something new). Array would then become [true, # of days, # of days left, completed? boolean];
        
        // Future functionality, setting a future start date to activate the habit:
        this.startDate = startDate; // Optional, user can decide a future start date for the habit. Default is now.
        
        // Initial states for when the object is created:
        this.doneToday = false;
        this.streakLog = [streakLayout, [0,0,0,0,0,0,0]];
        this.streak = 0;
        this.count = 0;
        this.freeze = false; // Future functionality, might get lumped into status instead.
    }
    checkOffToday(timeStamp){
        this.doneToday = true;
        this.streak += 1;
        this.count += 1;
        const dayIndex = timeStamp.getDay();
        const dayOfWeek = JSdaysLayout[dayIndex];
        const streakLayoutIndex = this.streakLog[0].indexOf(dayOfWeek);
        this.streakLog[1][streakLayoutIndex] = 1;
        return true;
    }
    uncheckToday(timeStamp){
        this.doneToday = false;
        this.streak -= 1;
        this.count -= 1;
        const dayIndex = timeStamp.getDay();
        const dayOfWeek = JSdaysLayout[dayIndex];
        const streakLayoutIndex = this.streakLog[0].indexOf(dayOfWeek);
        this.streakLog[1][streakLayoutIndex] = 0;
        return true;
    }
    deleteData(){
        // For deleting all the habit data from the JSON file before removing the habit.
        return true;
    }
}

class User{
    constructor(id, username, name, email){
        this.id = id;
        this.username = username;
        this.name = name;
        this.email = email;
        this.now = Date.now();
        this.joinDate = new Date(this.now);
        this.habitIdCount = 0;
        this.habits = [];
        this.lists = []; // Future functionality
        userCount += 1;
        console.log(`New user ${this.username} added. Name: ${this.name}, Email: ${this.email}.`);
        return userCount;
    }
    createHabit(title, description, frequency, reminderTime, status = "active", finite = [false, 0, 0, false], startDate = new Date(Date.now()), streakLayout = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]){
        const id = this.habitIdCount + 1;
        const habit = new Habit(id, title, description, frequency, reminderTime, status, finite, startDate, streakLayout);
        this.habits.push(habit);
        this.habitIdCount++;
        return habit;
    }
    removeHabit(removal_id, permaDelete){
        // Alternative will be archiving the habit.
        // const userConfirm = prompt(`Are you sure you want to delete this habit? This cannot be undone! y/N`);
        try{
            const habitToRemove = this.habits.find(({id}) => id === removal_id);
            if (!habitToRemove){throw new Error(`Could not find habit with id ${removal_id}! Habit does not exist or has already been removed.`);}
            if (permaDelete === true){
                habitToRemove.deleteData();
            }
            this.habits = this.habits.filter(habit => {return habit !== habitToRemove});
            console.log(`Habit with id ${removal_id} has been removed.`);
            return true;
        }catch(error){
            console.log(error.message);
        }
    }
    checkOffHabit(habit_id){
        const now = Date.now();
        const timeStamp = new Date(now);
        try{
            const habitToCheckOff = this.habits.find(({id}) => id === habit_id);
            if (!habitToCheckOff){throw new Error(`Could not find habit with id ${habit_id}!`);}
            if (habitToCheckOff.doneToday === true){throw new Error(`The habit with id ${habit_id} has already been checked off!`);}
            const checked = habitToCheckOff.checkOffToday(timeStamp);
            return checked;
        }catch(error){
            console.log(error.message);
        }
    }
    uncheckHabit(habit_id){
        const now = Date.now();
        const timeStamp = new Date(now);
        try{
            const habitToUncheck = this.habits.find(({id}) => id === habit_id);
            if (!habitToUncheck){throw new Error(`Could not find habit with id ${habit_id}!`);}
            if (habitToUncheck.doneToday === false){throw new Error(`The habit with id ${habit_id} is already unchecked!`);}
            const unchecked = habitToUncheck.uncheckToday(timeStamp);
            return unchecked;
        }catch(error){
            console.log(error.message);
        }
    }
    listHabits(){
        this.habits.forEach((habit) => console.log(habit));
    }
}

var users = [];
var userCount = 0;
var id = userCount + 1;
console.log(`User count is ${userCount}`);
const sophia = new User(id, "sophia", "Sophia D", "TheGiraffe@users.noreply.github.com");
console.log(`User count is ${userCount}`);
sophia.createHabit("Offline at 9","Turn phone off at 9 pm every night",[1,1,1,1,1,1,1],"20:00");
sophia.createHabit("Duolingo Latin","Complete at least 1 Duolingo Latin lesson every day",[1,1,1,1,1,1,1],"20:00");
sophia.createHabit("Duolingo Korean","Complete at least 1 Duolingo Korean lesson every day",[1,1,1,1,1,1,1],"20:00");
sophia.createHabit("Run 5K","Run 5 km on Monday, Wednesday, and Friday",[1,0,1,0,1,0,0],"05:00"); // I prefer my week to start on Mondays, so I'm gonna code it into here to compare the input frequency array with the user's specified week layout.
sophia.createHabit("A test habit for fun","testing",[0,0,0,0,0,1,0],"10:30");
sophia.listHabits();
sophia.removeHabit(5);
sophia.createHabit("10 mile run","Go for a long run (10 mi) on Saturday mornings",[0,0,0,0,0,1,0],"04:30");
sophia.listHabits();
