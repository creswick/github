{-# LANGUAGE DeriveDataTypeable, StandaloneDeriving #-}

module Github.Data.Definitions where

import Data.Time
import Data.Data
import Network.HTTP.Conduit (HttpException(..))
import qualified Control.Exception as E

deriving instance Eq Network.HTTP.Conduit.HttpException

-- | Errors have been tagged according to their source, so you can more easily
-- dispatch and handle them.
data Error =
    HTTPConnectionError E.IOException -- ^ A HTTP error occurred. The actual caught error is included, if available.
  | ParseError String -- ^ An error in the parser itself.
  | JsonError String -- ^ The JSON is malformed or unexpected.
  | UserError String -- ^ Incorrect input.
  deriving (Show, Eq)

-- | A date in the Github format, which is a special case of ISO-8601.
newtype GithubDate = GithubDate { fromGithubDate :: UTCTime }
  deriving (Show, Data, Typeable, Eq, Ord)

data Commit = Commit {
   commitSha       :: String
  ,commitParents   :: [Tree]
  ,commitUrl       :: String
  ,commitGitCommit :: GitCommit
  ,commitCommitter :: Maybe GithubUser
  ,commitAuthor    :: Maybe GithubUser
  ,commitFiles     :: [File]
  ,commitStats     :: Maybe Stats
} deriving (Show, Data, Typeable, Eq, Ord)

data Tree = Tree {
   treeSha :: String
  ,treeUrl :: String
  ,treeGitTrees :: [GitTree]
} deriving (Show, Data, Typeable, Eq, Ord)

data GitTree = GitTree {
  gitTreeType :: String
  ,gitTreeSha :: String
  ,gitTreeUrl :: String
  ,gitTreeSize :: Maybe Int
  ,gitTreePath :: String
  ,gitTreeMode :: String
} deriving (Show, Data, Typeable, Eq, Ord)

data GitCommit = GitCommit {
   gitCommitMessage :: String
  ,gitCommitUrl :: String
  ,gitCommitCommitter :: GitUser
  ,gitCommitAuthor :: GitUser
  ,gitCommitTree :: Tree
  ,gitCommitSha :: Maybe String
  ,gitCommitParents :: [Tree]
} deriving (Show, Data, Typeable, Eq, Ord)

data GithubUser = GithubUser {
   githubUserAvatarUrl :: String
  ,githubUserLogin :: String
  ,githubUserUrl :: String
  ,githubUserId :: Int
  ,githubUserGravatarId :: String
} deriving (Show, Data, Typeable, Eq, Ord)

data GitUser = GitUser {
   gitUserName  :: String
  ,gitUserEmail :: String
  ,gitUserDate  :: GithubDate
} deriving (Show, Data, Typeable, Eq, Ord)

data File = File {
   fileBlobUrl :: String
  ,fileStatus :: String
  ,fileRawUrl :: String
  ,fileAdditions :: Int
  ,fileSha :: String
  ,fileChanges :: Int
  ,filePatch :: String
  ,fileFilename :: String
  ,fileDeletions :: Int
} deriving (Show, Data, Typeable, Eq, Ord)

data Stats = Stats {
   statsAdditions :: Int
  ,statsTotal :: Int
  ,statsDeletions :: Int
} deriving (Show, Data, Typeable, Eq, Ord)

data Comment = Comment {
   commentPosition :: Maybe Int
  ,commentLine :: Maybe Int
  ,commentBody :: String
  ,commentCommitId :: String
  ,commentUpdatedAt :: UTCTime
  ,commentHtmlUrl :: Maybe String
  ,commentUrl :: String
  ,commentCreatedAt :: UTCTime
  ,commentPath :: Maybe String
  ,commentUser :: GithubUser
  ,commentId :: Int
} deriving (Show, Data, Typeable, Eq, Ord)

data Diff = Diff {
   diffStatus :: String
  ,diffBehindBy :: Int
  ,diffPatchUrl :: String
  ,diffUrl :: String
  ,diffBaseCommit :: Commit
  ,diffCommits :: [Commit]
  ,diffTotalCommits :: Int
  ,diffHtmlUrl :: String
  ,diffFiles :: [File]
  ,diffAheadBy :: Int
  ,diffDiffUrl :: String
  ,diffPermalinkUrl :: String
} deriving (Show, Data, Typeable, Eq, Ord)

data Gist = Gist {
   gistUser :: GithubUser
  ,gistGitPushUrl :: String
  ,gistUrl :: String
  ,gistDescription :: Maybe String
  ,gistCreatedAt :: GithubDate
  ,gistPublic :: Bool
  ,gistComments :: Int
  ,gistUpdatedAt :: GithubDate
  ,gistHtmlUrl :: String
  ,gistId :: String
  ,gistFiles :: [GistFile]
  ,gistGitPullUrl :: String
} deriving (Show, Data, Typeable, Eq, Ord)

data GistFile = GistFile {
   gistFileType :: String
  ,gistFileRawUrl :: String
  ,gistFileSize :: Int
  ,gistFileLanguage :: Maybe String
  ,gistFileFilename :: String
  ,gistFileContent :: Maybe String
} deriving (Show, Data, Typeable, Eq, Ord)

data GistComment = GistComment {
   gistCommentUser :: GithubUser
  ,gistCommentUrl :: String
  ,gistCommentCreatedAt :: GithubDate
  ,gistCommentBody :: String
  ,gistCommentUpdatedAt :: GithubDate
  ,gistCommentId :: Int
} deriving (Show, Data, Typeable, Eq, Ord)

data Blob = Blob {
   blobUrl :: String
  ,blobEncoding :: String
  ,blobContent :: String
  ,blobSha :: String
  ,blobSize :: Int
} deriving (Show, Data, Typeable, Eq, Ord)

data GitReference = GitReference {
   gitReferenceObject :: GitObject
  ,gitReferenceUrl :: String
  ,gitReferenceRef :: String
} deriving (Show, Data, Typeable, Eq, Ord)

data GitObject = GitObject {
   gitObjectType :: String
  ,gitObjectSha :: String
  ,gitObjectUrl :: String
} deriving (Show, Data, Typeable, Eq, Ord)

data Issue = Issue {
   issueClosedAt :: Maybe GithubDate
  ,issueUpdatedAt :: GithubDate
  ,issueHtmlUrl :: String
  ,issueClosedBy :: Maybe String
  ,issueLabels :: [IssueLabel]
  ,issueNumber :: Int
  ,issueAssignee :: Maybe GithubUser
  ,issueUser :: GithubUser
  ,issueTitle :: String
  ,issuePullRequest :: PullRequestReference
  ,issueUrl :: String
  ,issueCreatedAt :: GithubDate
  ,issueBody :: String
  ,issueState :: String
  ,issueId :: Int
  ,issueComments :: Int
  ,issueMilestone :: Maybe Milestone
} deriving (Show, Data, Typeable, Eq, Ord)

data Milestone = Milestone {
   milestoneCreator :: GithubUser
  ,milestoneDueOn :: GithubDate
  ,milestoneOpenIssues :: Int
  ,milestoneNumber :: Int
  ,milestoneClosedIssues :: Int
  ,milestoneDescription :: String
  ,milestoneTitle :: String
  ,milestoneUrl :: String
  ,milestoneCreatedAt :: GithubDate
  ,milestoneState :: String
} deriving (Show, Data, Typeable, Eq, Ord)

data IssueLabel = IssueLabel {
   labelColor :: String
  ,labelUrl :: String
  ,labelName :: String
} deriving (Show, Data, Typeable, Eq, Ord)

data PullRequestReference = PullRequestReference {
  pullRequestReferenceHtmlUrl :: Maybe String
  ,pullRequestReferencePatchUrl :: Maybe String
  ,pullRequestReferenceDiffUrl :: Maybe String
} deriving (Show, Data, Typeable, Eq, Ord)

data IssueComment = IssueComment {
   issueCommentUpdatedAt :: GithubDate
  ,issueCommentUser :: GithubUser
  ,issueCommentUrl :: String
  ,issueCommentCreatedAt :: GithubDate
  ,issueCommentBody :: String
  ,issueCommentId :: Int
} deriving (Show, Data, Typeable, Eq, Ord)

-- | Data describing an @Event@.
data EventType =
    Mentioned     -- ^ The actor was @mentioned in an issue body.
  | Subscribed    -- ^ The actor subscribed to receive notifications for an issue.
  | Unsubscribed  -- ^ The issue was unsubscribed from by the actor.
  | Referenced    -- ^ The issue was referenced from a commit message. The commit_id attribute is the commit SHA1 of where that happened.
  | Merged        -- ^ The issue was merged by the actor. The commit_id attribute is the SHA1 of the HEAD commit that was merged.
  | Assigned      -- ^ The issue was assigned to the actor.
  | Closed        -- ^ The issue was closed by the actor. When the commit_id is present, it identifies the commit that closed the issue using “closes / fixes #NN” syntax. 
  | Reopened      -- ^ The issue was reopened by the actor.
  deriving (Show, Data, Typeable, Eq, Ord)

data Event = Event {
   eventActor :: GithubUser
  ,eventType :: EventType
  ,eventCommitId :: Maybe String
  ,eventUrl :: String
  ,eventCreatedAt :: GithubDate
  ,eventId :: Int
  ,eventIssue :: Maybe Issue
} deriving (Show, Data, Typeable, Eq, Ord)

data SimpleOrganization = SimpleOrganization {
   simpleOrganizationUrl :: String
  ,simpleOrganizationAvatarUrl :: String
  ,simpleOrganizationId :: Int
  ,simpleOrganizationLogin :: String
} deriving (Show, Data, Typeable, Eq, Ord)

data Organization = Organization {
   organizationType :: String
  ,organizationBlog :: Maybe String
  ,organizationLocation :: Maybe String
  ,organizationLogin :: String
  ,organizationFollowers :: Int
  ,organizationCompany :: Maybe String
  ,organizationAvatarUrl :: String
  ,organizationPublicGists :: Int
  ,organizationHtmlUrl :: String
  ,organizationEmail :: Maybe String
  ,organizationFollowing :: Int
  ,organizationPublicRepos :: Int
  ,organizationUrl :: String
  ,organizationCreatedAt :: GithubDate
  ,organizationName :: Maybe String
  ,organizationId :: Int
} deriving (Show, Data, Typeable, Eq, Ord)

data PullRequest = PullRequest {
   pullRequestClosedAt :: Maybe GithubDate
  ,pullRequestCreatedAt :: GithubDate
  ,pullRequestUser :: GithubUser
  ,pullRequestPatchUrl :: String
  ,pullRequestState :: String
  ,pullRequestNumber :: Int
  ,pullRequestHtmlUrl :: String
  ,pullRequestUpdatedAt :: GithubDate
  ,pullRequestBody :: String
  ,pullRequestIssueUrl :: String
  ,pullRequestDiffUrl :: String
  ,pullRequestUrl :: String
  ,pullRequestLinks :: PullRequestLinks
  ,pullRequestMergedAt :: Maybe GithubDate
  ,pullRequestTitle :: String
  ,pullRequestId :: Int
} deriving (Show, Data, Typeable, Eq, Ord)

data DetailedPullRequest = DetailedPullRequest {
  -- this is a duplication of a PullRequest
   detailedPullRequestClosedAt :: Maybe GithubDate
  ,detailedPullRequestCreatedAt :: GithubDate
  ,detailedPullRequestUser :: GithubUser
  ,detailedPullRequestPatchUrl :: String
  ,detailedPullRequestState :: String
  ,detailedPullRequestNumber :: Int
  ,detailedPullRequestHtmlUrl :: String
  ,detailedPullRequestUpdatedAt :: GithubDate
  ,detailedPullRequestBody :: String
  ,detailedPullRequestIssueUrl :: String
  ,detailedPullRequestDiffUrl :: String
  ,detailedPullRequestUrl :: String
  ,detailedPullRequestLinks :: PullRequestLinks
  ,detailedPullRequestMergedAt :: Maybe GithubDate
  ,detailedPullRequestTitle :: String
  ,detailedPullRequestId :: Int

  ,detailedPullRequestMergedBy :: Maybe GithubUser
  ,detailedPullRequestChangedFiles :: Int
  ,detailedPullRequestHead :: PullRequestCommit
  ,detailedPullRequestComments :: Int
  ,detailedPullRequestDeletions :: Int
  ,detailedPullRequestAdditions :: Int
  ,detailedPullRequestReviewComments :: Int
  ,detailedPullRequestBase :: PullRequestCommit
  ,detailedPullRequestCommits :: Int
  ,detailedPullRequestMerged :: Bool
  ,detailedPullRequestMergeable :: Bool
} deriving (Show, Data, Typeable, Eq, Ord)

data PullRequestLinks = PullRequestLinks {
   pullRequestLinksReviewComments :: String
  ,pullRequestLinksComments :: String
  ,pullRequestLinksHtml :: String
  ,pullRequestLinksSelf :: String
} deriving (Show, Data, Typeable, Eq, Ord)

data PullRequestCommit = PullRequestCommit {
} deriving (Show, Data, Typeable, Eq, Ord)

data Repo = Repo {
   repoSshUrl :: String
  ,repoDescription :: String
  ,repoCreatedAt :: GithubDate
  ,repoHtmlUrl :: String
  ,repoSvnUrl :: String
  ,repoForks :: Int
  ,repoHomepage :: Maybe String
  ,repoFork :: Bool
  ,repoGitUrl :: String
  ,repoPrivate :: Bool
  ,repoCloneUrl :: String
  ,repoSize :: Int
  ,repoUpdatedAt :: GithubDate
  ,repoWatchers :: Int
  ,repoOwner :: GithubUser
  ,repoName :: String
  ,repoLanguage :: String
  ,repoMasterBranch :: Maybe String
  ,repoPushedAt :: GithubDate
  ,repoId :: Int
  ,repoUrl :: String
  ,repoOpenIssues :: Int
  ,repoHasWiki :: Maybe Bool
  ,repoHasIssues :: Maybe Bool
  ,repoHasDownloads :: Maybe Bool
} deriving (Show, Data, Typeable, Eq, Ord)

data Contributor
  -- | An existing Github user, with their number of contributions, avatar
  -- URL, login, URL, ID, and Gravatar ID.
  = KnownContributor Int String String String Int String
  -- | An unknown Github user with their number of contributions and recorded name.
  | AnonymousContributor Int String
 deriving (Show, Data, Typeable, Eq, Ord)

-- | This is only used for the FromJSON instance.
data Languages = Languages { getLanguages :: [Language] }
  deriving (Show, Data, Typeable, Eq, Ord)

-- | A programming language with the name and number of characters written in
-- it.
data Language = Language String Int
 deriving (Show, Data, Typeable, Eq, Ord)

data Tag = Tag {
   tagName :: String
  ,tagZipballUrl :: String
  ,tagTarballUrl :: String
  ,tagCommit :: BranchCommit
} deriving (Show, Data, Typeable, Eq, Ord)

data Branch = Branch {
   branchName :: String
  ,branchCommit :: BranchCommit
} deriving (Show, Data, Typeable, Eq, Ord)

data BranchCommit = BranchCommit {
   branchCommitSha :: String
  ,branchCommitUrl :: String
} deriving (Show, Data, Typeable, Eq, Ord)

data DetailedUser = DetailedUser {
   detailedUserCreatedAt :: GithubDate
  ,detailedUserType :: String
  ,detailedUserPublicGists :: Int
  ,detailedUserAvatarUrl :: String
  ,detailedUserFollowers :: Int
  ,detailedUserFollowing :: Int
  ,detailedUserHireable :: Bool
  ,detailedUserGravatarId :: String
  ,detailedUserBlog :: Maybe String
  ,detailedUserBio :: Maybe String
  ,detailedUserPublicRepos :: Int
  ,detailedUserName :: Maybe String
  ,detailedUserLocation :: Maybe String
  ,detailedUserCompany :: Maybe String
  ,detailedUserEmail :: String
  ,detailedUserUrl :: String
  ,detailedUserId :: Int
  ,detailedUserHtmlUrl :: String
  ,detailedUserLogin :: String
} deriving (Show, Data, Typeable, Eq, Ord)

data GistPublicity = PublicGist | PrivateGist
  deriving (Show, Eq)

data NewGist = NewGist GistPublicity (Maybe String) [NewGistFile]
  deriving (Show, Eq)

data NewGistFile = NewGistFile String String
  deriving (Show, Eq)

data GistDetail = GistDetail {
   gistDetailComments :: Int
  ,gistDetailUpdatedAt :: GithubDate
  ,gistDetailGitPushUrl :: String
  ,gistDetailUser :: Maybe GithubUser
  ,gistDetailPublic :: Bool
  ,gistDetailHtmlUrl :: String
  ,gistDetailCreatedAt :: GithubDate
  ,gistDetailDescription :: String
  ,gistDetailFiles :: [GistFile]
  ,gistDetailGitPullUrl :: String
  ,gistDetailId :: String
  ,gistDetailUrl :: String
  ,gistDetailHistory :: [GistHistory]
} deriving (Show, Data, Typeable, Eq, Ord)

data GistHistory = GistHistory {
   gistHistoryUser :: Maybe GithubUser
  ,gistHistoryVersion :: String
  ,gistHistoryChangeStatus :: ChangeStatus
  ,gistHistoryCommitedAt :: String
  ,gistHistoryUrl :: String
} deriving (Show, Data, Typeable, Eq, Ord)

data ChangeStatus = ChangeStatus {
   changeStatusAdditions :: Int
  ,changeStatusDeletions :: Int
  ,changeStatusTotal :: Int
} deriving (Show, Data, Typeable, Eq, Ord)
