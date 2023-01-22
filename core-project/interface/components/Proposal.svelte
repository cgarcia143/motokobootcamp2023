<script>
  export let post
</script>


<div class="post-preview">
  <h2>{BigInt(post[0]).toString()}</h2>
  <p>{post[1].user.toString()}</p>
  <p>Change website text to: {post[1].title}</p>
  <p>
    Yes: {(post[1].votes.yes / BigInt(100000000)).toString()}, No: {(
      post[1].votes.no / BigInt(100000000)
    ).toString()}
  </p>
</div>


<style>
  .post-preview {
    border: 1px solid white;
    border-radius: 10px;
    margin-bottom: 2vmin;
    padding: 2vmin;
  }
  h2 {
    color: white;
  }

  p {
    color: white;
  }
</style>
