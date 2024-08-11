const messages = document.getElementById('scroll');



let scrollAt = () => {
    let scrollTop = messages.scrollTop 
    let scrollHeight = messages.scrollHeight
    let clientHeight = messages.clientHeight

    return scrollTop / (scrollHeight - clientHeight) * 100
}

InfiniteScroll = {
    page() { return this.el.dataset.page },
    mounted(){
        this.pending = this.page()
        this.el.addEventListener("scroll", e => {
            if(this.pending == this.page() && scrollAt() == 0){
                this.pending = this.page() + 1
                this.pushEvent("load-messages", {})
                document.getElementById('loadind').style = "display: block"
            }
        })
    },
    reconnected(){ 
         this.pending = this.page() },
    updated(){ 
        this.pending = this.page() 
        document.getElementById('loadind').style = "display: none"
    }
}

export default InfiniteScroll