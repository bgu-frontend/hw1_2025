## Introduction
We will implement a simple front-end app that shows user notes. The app uses a JSON server, which uses a JSON file as a note database and displays the notes to the user, split into pages.

1. A JSON server is initialized using a JSON file to hold the notes. The JSON file is initially small, but you will replace it with your own, much larger, JSON file.
2. The client sees the notes, which are split into pages: 10 notes at a page. Initially, only the first page is shown to the user.
3. The UI component used is called pagination. 
4. When a specific page loads, only the messages of that page will be sent from the server for obvious efficiency reasons.

## Submission
1. Submission is in pairs, but starting alone is better for practice.
2. Coding: 70%, Questions: 30%.
3. Your submitted git repo should be *private*, please make 'barashd@post.bgu.ac.il', 'Gurevichronen@gmail.com', 'daninost', and 'Gal-Fadlon' as collaborators.
4. Do not use external libraries that provide the pagination component. If in doubt, contact the course staff.
5. Deadline: 23.4.25, end of day.
6. Additionally, solve the [theoretical questions](https://forms.gle/zGDQF3DcPaA6iqCw6).
7. Fill in repository ssh clone link in the course Moodle's git submission area. 
8. Use TypeScript, and follow the linter's warnings (see eslint below).
9. The ex1 forum is open for questions in Moodle.
10. Git repository content:
    1. Aim for a minimal repository size that can be cloned and installed: most of the files in github should be code and package dependencies (add package.json, index.html).
    2. Don't submit (add to git)  node_modules dir, package-lock.json, or json files. Read about .gitignore and see the example in the repo.
11. If a certain case is not described here, you're free to code it as you see fit.
12. the submission commit will be tagged as "a1": [git tagging](https://git-scm.com/book/en/v2/Git-Basics-Tagging)
    1. `git tag -a submission_hw1 -m "msg"`
    2. `git push origin --tags`
    3. if you need to tag a new commit as the solution, first delete `git tag -d submission_hw1` or add `--force`.
13. to test your submission, run the presubmission script (in github). A submission that does not pass the presubmission script, gets a 0 score automatically.
    1. For example: `bash presubmission.sh git@github.com:bgu-frontend/hw1_2025.git`
14. It is recommended to add test to your code and it usually results in higher grades during the automatic testing.  See 'Playwright' below.

## AI
Recommendation about using an AI assistant: You can ask questions and read the answers, but avoid copying them. Understand the details but write the code yourself.
Requirements for AI usage:
1. If you use an AI assistant (e.g., ChatGPT, Claude, etc.), you must share your conversation with the AI:
    - Use the "share" option provided by the AI tool to generate a link to the conversation.
    - If the tool does not have a "share" option, provide a PDF containing screenshots of the chat.
2. Submit the shared conversation link or PDF along with your homework.
3. You are expected to fully understand your own code, and be able to answer questions about it, frontally.

## Plagiarism
1. We use a plagiarism detector.
2. The person who copies and the person who was copied from are both responsible. Set your repository private, and don't share your code.
3. If the code was copied from an AI agent, we expect it to appear in the shared conversation above.
4. Exception: You can share tests.


### Github 
HW1 will be submitted via Github. Please open a user with your email address.
To securely update files from your machine by SSH authentication:
https://docs.github.com/en/authentication/connecting-to-github-with-ssh/checking-for-existing-ssh-keys 

## Prerequisites
### Tools
1. Chrome browser (comes with DevTools built-in).
2. Visual Studio Code
3. Optional: Visual Studio Code [debugger](https://code.visualstudio.com/docs/)
3. [Vite](https://vitejs.dev/guide/)
4. Git (Start here: [Atlassian](https://www.atlassian.com/git/tutorials/))



### Git - useful to know
1. clone
2. add
3. commit
4. push


### Json server - example code
In the following, `active_page` is the currently displayed page, and `POSTS_PER_PAGE` is 10, 'notes_url' is 'http://localhost:3001/notes'.
```js

    useEffect(() => {
        const promise = axios.get(NOTES_URL, {
            params: {
              _page: activePage,
              _per_page: POSTS_PER_PAGE
            }});
        promise.then(response => { 
            // fill
        }).catch(error => { console.log("Encountered an error:" + error)});
    }, []);
```

See:
https://www.npmjs.com/package/json-server
For pagination, you'll need request:
```
_page
_per_page
_limit
```
query parameters, please read the relevant docs.

### Github 
HW1 will be submitted by sharing a github link to your private repository. If you don't have a Git user, please create one with your BGU email address.

## Starting a new project:
1. Initiate a new repository or clone this one.
2. Start a new React project using Vite. Run:
```bash
npm create vite@latest <your_app_name> -- --template react-ts
cd my-app
npm install
``` 
3. Install json-server locally
```bash
npm install json-server@0.17.4
```
4. Create and seed the database
Recommendation: Create a script that creates a JSON file with the number of posts given by an input N in the same format as 'notes.json.'
Use it to initialize a JSON file in, e.g., "./data/notes.json."
5. Avoid installing your project's packages globally.
    Explanation: We use npm to install packages locally in our project, package.json file tracks those. When you install packages via npm globally, you risk that a package would be installed on your machine but not on others, since it's not tracked by package.json.

## Code
1. Aim for short components, with organized component directory hierarchy. See vite's initial project structure as an example.


### Run the server with an input JSON file:
```bash
npx json-server --port 3001 --watch ./data/notes.json
```

### Run your code:
```bash
cd <vite_project_path>
npm run dev
```
## Front end Description:
1. The front-end should connect to the server, and get posts (just) for the current page.
2. Each page has 10 posts.
3. add [pagination](https://www.w3schools.com/css/css3_pagination.asp) UI element to the website. 

## Suggested implementation steps:
1. Show a list of posts (tip: start from a local variable holding the post list.)
2. Connect to the server: (tip: start by getting all posts.)
3. Add pagination in the UI (tip: plan the component tree: who is using who?). 
4. Optimize: when rendering a page, send only the data needed now instead of the entire database.
5. Tip: write a test plan. how would you test someone else's project? this suggests implementation priorities.

## Pagination
1. The minimum number of page buttons is 1.
2. The maximum number of page buttons is 5.
3. The first page is 1.
4. The Active page button is shown in bold.
5. The 4 buttons with "First, Prev, Next, Last" text on them always appear.
6. Which page numbers should be shown on the buttons? Let `a` be the current page. 
    1. If there are <=5 total pages, show buttons [1, ..., , #Num_pages].
    2. If there are >=6 total pages, assume there are 10 ( but implement for any number of pages):
        1. if `a <3` : show buttons `[1,2,3,4,5]`
        2. if `3 <= a <= 8` : show buttons `[a-2,a-1,a,a+1,a+2]`
        3. if `a > 8`: show buttons `[6,7,8,9,10]`
7. Disable irrelevant page buttons:
    1. `previous` is disabled if we're at the first page.
    2. `next` is disabled if we're at the last page.
    3. The current page number: if we're at page number 1, disable page button `1`.


## Checking the coding task:

## Test requirements
1. Each note should be of [class name](https://www.w3schools.com/html/html_classes.asp) **"note"**.
2. A note must get the unique ID from the database and use it as the [html id attribute](https://www.w3schools.com/html/html_id.asp).
3. Pagination buttons:
    1. Navigation buttons should be with [html name attribute](https://www.w3schools.com/tags/att_name.asp) **"first"**, **"previous"**, **"next"**, **"last"**.
    2. Page buttons should be with the [html name attribute](https://www.w3schools.com/tags/att_name.asp) **"page-<target_page_number>"**

### The tester will:
1. Clone and install your submitted GitHub repository.
    1. `git clone <your_submitted_github_repo>`
    2. `cd <cloned dir>`
    3.  checkout the submission tag
    4. `npm install` (package.json should exist)
    5. `npm run dev` (configured to default port 3000)
2. Start the server with a JSON file. It will always contain at least one note.
    1. `npx json-server --port 3001 ./data/notes.json`
3. Run tests (see one test example in the presubmission script).

### Example HTML
```
<div class="note" id="1">
    <h2>Note 1</h2>
    <small>By Author 1</small>
    <br>
    Content for note 1
</div>
```

```
<div>
    <button name="first">First</button>
    <button name="previous">Previous</button>
    <button name="page-1">1</button>
    <button name="page-2">2</button>
    <button name="page-3">3</button>
    <button name="page-4">4</button>
    <button name="page-5">5</button>
    <button name="next">Next</button>
    <button name="last">Last</button>
</div>
```


## Using `.eslintrc.json` 


1. **Install ESLint**:
```bash
npm install --save-dev eslint
```

2. **Place `.eslintrc.json`** in your project root (same level as `package.json`).

3. **Run ESLint**:
```bash
npm run lint
```

4. **Ensure `lint` script exists** in `package.json`:
```json
"scripts": {
  "lint": "eslint ."
}
```



## Using Playwright for Testing

To use Playwright for testing in your project, see the presubmission script for example, and read [writing-tests](https://playwright.dev/docs/writing-tests).

## Quick clean:
in `package.json`:
```json
"scripts": {
  "clean": "rm -rf node_modules package-lock.json"
}
```
