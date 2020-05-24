(function(){

  async function deleteImage(imageId) {
    try {
      let res = await axios.delete('/photos/delete', {params: { imageId}})
      res = res.data
      console.log(res)
    }
    catch (e) {
      console.log(e)
    }
  }
  
  // Get the modal
  let modal = document.getElementById("myModal");

  // Get the image and insert it inside the modal - use its "alt" text as a caption
  let img = $(".image-modal");
  let modalImg = $("#img01");
  let captionText = document.getElementById("caption");
  let photoId

  img.click(function(){
    modal.style.display = "block";
    let newSrc = this.src;
    modalImg.attr('src', newSrc);
    captionText.innerHTML = this.alt;
    photoId = this.dataset.photo;
  });

  // Get the <span> element that closes the modal
  let span = document.getElementsByClassName("close")[0];

  // When the user clicks on <span> (x), close the modal
  span.onclick = function() {
    modal.style.display = "none";
  }

  // When user click delete button, Delete the image and send a delete request to backend to delete photo from album
  let form = document.getElementById('delete-photo-form');
  form.addEventListener('submit', e => {
    e.preventDefault()
    let image = $(`[data-photo=${photoId}]`) // Get the image that was clicked based on dataset
    image[0].parentElement.remove() // Remove the image and its parent element.
    //Delete Request to backend.
    deleteImage(photoId)
    modal.style.display ="none"})
})()

